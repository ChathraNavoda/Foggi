import 'package:cloud_firestore/cloud_firestore.dart';

class FogOfLiesLeaderboardService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTopScores({int limit = 20}) async {
    final snapshot = await _firestore
        .collection('fog_of_lies_leaderboard')
        .orderBy('score', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final snapshot = await _firestore
        .collection('fog_of_lies_leaderboard')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getMyScores(String uid) async {
    final snapshot = await _firestore
        .collection('fog_of_lies_leaderboard')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
