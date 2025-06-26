// lib/logic/blocs/leaderboard/leaderboard_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foggi/data/models/leaderboard_entry.dart';

import 'leaderboard_event.dart';
import 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final FirebaseFirestore firestore;

  LeaderboardBloc({required this.firestore}) : super(LeaderboardInitial()) {
    on<LoadLeaderboard>(_onLoadLeaderboard);
  }

  Future<void> _onLoadLeaderboard(
    LoadLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());

    try {
      final snapshot = await firestore.collection('leaderboard').get();

      final allEntries = snapshot.docs.map((doc) {
        final data = doc.data();
        return LeaderboardEntry(
          uid: data['uid'] ?? '',
          displayName: data['displayName'] ?? 'Anonymous',
          avatar: data['avatar'] ?? '👻',
          score: data['score'] ?? 0,
          timestamp: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
          bestScore: data['score'] ?? 0, // Used in sorting
        );
      }).toList();

      emit(LeaderboardLoaded(allEntries));
    } catch (e) {
      emit(LeaderboardError('Failed to load leaderboard: ${e.toString()}'));
    }
  }
}
