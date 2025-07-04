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
        final correct = data['correctAnswer'] as String?;
        final fake = data['fakeAnswer'] as String?;
        final chosen = data['chosenAnswer'] as String?;
        final guesser = data['guesserUid'] as String?;

        if (correct == null ||
            fake == null ||
            chosen == null ||
            guesser == null) {
          print("⚠️ Missing result data. Waiting...");
          return;
        }

        emit(FogOfLiesRoundResult(
          isCorrect: chosen == correct,
          correctAnswer: correct,
          fakeAnswer: fake,
          chosenAnswer: chosen,
          guesserUid: guesser,
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

    // ✅ Use proper guesser based on round
    final currentRound = data['round'] ?? 0;
    final p1 = FogOfLiesPlayer.fromMap(data['player1']);
    final p2 = FogOfLiesPlayer.fromMap(data['player2']);
    final currentGuesser = currentRound % 2 == 0 ? p2 : p1;
    final guesserId = currentGuesser.uid;

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
      'guesserUid': guesserId,
    };

    final history = List<Map<String, dynamic>>.from(data['history'] ?? []);
    history.add(roundData);

    await _firestore.collection('fog_of_lies_games').doc(gameId).update({
      'phase': 'result',
      'chosenAnswer': event.chosenAnswer,
      'scores': scores,
      'guesserUid': guesserId,
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
      await _saveFogOfLiesScores(Map<String, int>.from(data['scores']));

      // Fetch scores again
      final scoresSnapshot =
          await _firestore.collection('fog_of_lies_games').doc(gameId).get();
      final currentScores = scoresSnapshot.data()?['scores'] ?? {};

      await _firestore.collection('fog_of_lies_games').doc(gameId).update({
        'phase': 'gameover',
        'scores': currentScores,
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

  Future<void> _saveFogOfLiesScores(Map<String, int> scores) async {
    final scoresRef = FirebaseFirestore.instance.collection('users');
    final leaderboardRef =
        FirebaseFirestore.instance.collection('fog_of_lies_leaderboard');

    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final players = [player1, player2];

    for (var player in players) {
      final newScore = scores[player.uid] ?? 0;

      final userRef = scoresRef.doc(player.uid); // ✅ This is the fix
      final userSnapshot = await userRef.get();
      final userData = userSnapshot.data() ?? {};

      final displayName = userData['displayName'] ?? player.name;
      final avatar = userData['avatar'] ?? player.avatar;

      // ✅ Only update personal score if this is the current user
      if (player.uid == currentUid) {
        final previousBest = userData['fogOfLiesBestScore'] ?? 0;

        await userRef.set({
          'fogOfLiesBestScore':
              newScore > previousBest ? newScore : previousBest,
          'fogOfLiesScores': FieldValue.arrayUnion([
            {
              'score': newScore,
              'date': DateTime.now().toIso8601String(),
            }
          ])
        }, SetOptions(merge: true));
      }

      // ✅ Add all scores to global leaderboard
      await leaderboardRef.add({
        'uid': player.uid,
        'displayName': displayName,
        'score': newScore,
        'avatar': avatar,
        'date': DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  Future<void> close() {
    _gameSub.cancel();
    return super.close();
  }
}
