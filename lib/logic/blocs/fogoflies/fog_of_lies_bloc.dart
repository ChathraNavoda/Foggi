import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/fogoflies/fog_of_lies_models.dart';
import '../../../data/models/riddle.dart';
import 'fog_of_lies_event.dart';
import 'fog_of_lies_state.dart';

class FogOfLiesBloc extends Bloc<FogOfLiesEvent, FogOfLiesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String gameId;

  late FogOfLiesPlayer player1;
  late FogOfLiesPlayer player2;
  late StreamSubscription<DocumentSnapshot> _gameSub;

  FogOfLiesBloc({required this.gameId}) : super(FogOfLiesInitial()) {
    on<StartFogOfLiesGame>(_onStartGame);
    on<SubmitFakeAnswer>(_onSubmitFakeAnswer);
    on<SubmitGuess>(_onSubmitGuess);
    on<NextFogOfLiesRound>(_onNextRound);

    _listenToGameState();
  }

  void _listenToGameState() {
    _gameSub = _firestore
        .collection('fog_of_lies_games')
        .doc(gameId)
        .snapshots()
        .listen((doc) {
      final data = doc.data();
      if (data == null) return;

      print("🧩 Firestore update received for gameId: $gameId");
      print("📦 Game data: $data");

      final phase = data['phase'];
      final round = data['round'] ?? 0;

      player1 = FogOfLiesPlayer.fromMap(data['player1']);
      player2 = FogOfLiesPlayer.fromMap(data['player2']);

      print("🎭 Player1: ${player1.uid}, Player2: ${player2.uid}");
      print("🔁 Phase: $phase, Round: $round");

      if (phase == 'bluffing' || phase == 'guessing') {
        final currentRiddler = round % 2 == 0 ? player1 : player2;
        final currentGuesser = round % 2 == 0 ? player2 : player1;

        print(
            "🕵️‍♂️ Current Riddler: ${currentRiddler.uid}, Guesser: ${currentGuesser.uid}");

        emit(FogOfLiesInProgress(
          currentRiddler: currentRiddler,
          currentGuesser: currentGuesser,
          riddle: data['riddle'],
          correctAnswer: data['correctAnswer'],
          fakeAnswer: data['fakeAnswer'],
        ));
      } else if (phase == 'result') {
        print("🏁 Showing round result");
        emit(FogOfLiesRoundResult(
          isCorrect: data['chosenAnswer'] == data['correctAnswer'],
          correctAnswer: data['correctAnswer'],
          fakeAnswer: data['fakeAnswer'],
          chosenAnswer: data['chosenAnswer'],
        ));
      } else if (phase == 'gameover') {
        print("🏁 Game over with scores: ${data['scores']}");
        emit(FogOfLiesGameOver(
          Map<String, int>.from(data['scores']),
          (data['history'] as List)
              .map((e) => FogOfLiesRound.fromMap(e))
              .toList(),
        ));
      }
    });
  }

  Future<void> _onStartGame(StartFogOfLiesGame event, Emitter emit) async {
    player1 = event.player1;
    player2 = event.player2;

    final riddle = RiddleRepository().getRiddles(count: 1).first;

    print("🚀 Starting game with ${player1.name} and ${player2.name}");

    await _firestore.collection('fog_of_lies_games').doc(gameId).set({
      'player1': player1.toMap(),
      'player2': player2.toMap(),
      'riddle': riddle.question,
      'correctAnswer': riddle.answer,
      'phase': 'bluffing',
      'round': 0,
      'scores': {
        player1.uid: 0,
        player2.uid: 0,
      },
      'history': [],
    });
  }

  Future<void> _onSubmitFakeAnswer(SubmitFakeAnswer event, Emitter emit) async {
    print("📨 Submitting fake answer: ${event.fakeAnswer}");
    await _firestore.collection('fog_of_lies_games').doc(gameId).update({
      'fakeAnswer': event.fakeAnswer,
      'phase': 'guessing',
    });
  }

  Future<void> _onSubmitGuess(SubmitGuess event, Emitter emit) async {
    final doc =
        await _firestore.collection('fog_of_lies_games').doc(gameId).get();
    final data = doc.data();
    if (data == null) return;

    final correct = data['correctAnswer'];
    final scores = Map<String, int>.from(data['scores']);
    final guesserId = FirebaseAuth.instance.currentUser!.uid;

    print("🕹️ Submitting guess: ${event.chosenAnswer}");
    print("✅ Correct answer: $correct");

    if (event.chosenAnswer == correct) {
      print("🎯 Correct guess by $guesserId");
      scores[guesserId] = (scores[guesserId] ?? 0) + 1;
    } else {
      print("❌ Wrong guess by $guesserId");
    }

    final roundData = {
      'riddle': data['riddle'],
      'correctAnswer': correct,
      'fakeAnswer': data['fakeAnswer'],
      'chosenAnswer': event.chosenAnswer,
      'isCorrect': event.chosenAnswer == correct,
    };

    final history = List<Map<String, dynamic>>.from(data['history'] ?? []);
    history.add(roundData);

    await _firestore.collection('fog_of_lies_games').doc(gameId).update({
      'phase': 'result',
      'chosenAnswer': event.chosenAnswer,
      'scores': scores,
      'history': history,
    });
  }

  Future<void> _onNextRound(NextFogOfLiesRound event, Emitter emit) async {
    final doc =
        await _firestore.collection('fog_of_lies_games').doc(gameId).get();
    final data = doc.data();
    if (data == null) return;

    final round = (data['round'] ?? 0) + 1;
    print("🔁 Moving to round $round");

    if (round >= 6) {
      print("🏁 Reached max rounds. Ending game.");
      await _firestore.collection('fog_of_lies_games').doc(gameId).update({
        'phase': 'gameover',
      });
      return;
    }

    final riddle = RiddleRepository().getRiddles(count: 1).first;

    await _firestore.collection('fog_of_lies_games').doc(gameId).update({
      'round': round,
      'riddle': riddle.question,
      'correctAnswer': riddle.answer,
      'fakeAnswer': null,
      'chosenAnswer': null,
      'phase': 'bluffing',
    });
  }

  @override
  Future<void> close() {
    _gameSub.cancel();
    return super.close();
  }
}
