import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final String uid;
  final String displayName;
  final String avatar;
  final int score;
  final DateTime timestamp;
  final int bestScore;

  const LeaderboardEntry({
    required this.uid,
    required this.displayName,
    required this.avatar,
    required this.score,
    required this.timestamp,
    required this.bestScore,
  });

  @override
  List<Object?> get props =>
      [uid, displayName, avatar, score, timestamp, bestScore];
}
