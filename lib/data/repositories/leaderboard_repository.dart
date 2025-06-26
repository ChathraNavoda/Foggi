// lib/features/leaderboard/repository/leaderboard_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/leaderboard_entry.dart';

class LeaderboardRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> saveScore(int score) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = _db.collection('users').doc(user.uid);

    final userData = {
      'displayName': user.displayName ?? 'Anonymous',
      'email': user.email ?? '',
      'avatar':
          user.photoURL ?? '👻', // fallback if you're using emoji manually
      'scores': FieldValue.arrayUnion([
        {
          'score': score,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ]),
    };

    await userDoc.set(userData, SetOptions(merge: true));
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final snapshot = await _db.collection('users').get();

    final allEntries = <LeaderboardEntry>[];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final scores = List<Map<String, dynamic>>.from(data['scores'] ?? []);

      // 🔍 Find the best score from the array
      final int bestScore = scores
          .map((e) => e['score'] ?? 0)
          .whereType<int>()
          .fold(0, (prev, curr) => curr > prev ? curr : prev);

      for (var score in scores) {
        allEntries.add(
          LeaderboardEntry(
            uid: doc.id,
            displayName: data['displayName'] ?? 'Anonymous',
            avatar: data['avatar'] ?? '👻',
            score: score['score'] ?? 0,
            timestamp:
                DateTime.tryParse(score['timestamp'] ?? '') ?? DateTime.now(),
            bestScore: bestScore, // ✅ set here
          ),
        );
      }
    }

    // Sort by score descending
    allEntries.sort((a, b) => b.score.compareTo(a.score));

    return allEntries;
  }
}
