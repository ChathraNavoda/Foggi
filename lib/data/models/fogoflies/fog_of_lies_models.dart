class FogOfLiesPlayer {
  final String uid;
  final String name;
  final String avatar;

  FogOfLiesPlayer({
    required this.uid,
    required this.name,
    required this.avatar,
  });

  factory FogOfLiesPlayer.fromMap(Map<String, dynamic> map) {
    return FogOfLiesPlayer(
      uid: map['uid'] as String,
      name:
          map['name'] as String? ?? map['displayName'] as String? ?? 'Unknown',
      avatar: map['avatar'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'avatar': avatar,
    };
  }
}

class FogOfLiesRound {
  final String riddle;
  final String correctAnswer;
  final String fakeAnswer;
  final String chosenAnswer;
  final bool isCorrect;
  final String guesserUid; // ✅ Add this

  FogOfLiesRound({
    required this.riddle,
    required this.correctAnswer,
    required this.fakeAnswer,
    required this.chosenAnswer,
    required this.isCorrect,
    required this.guesserUid, // ✅ Add this to constructor
  });

  factory FogOfLiesRound.fromMap(Map<String, dynamic> map) {
    return FogOfLiesRound(
      riddle: map['riddle'] as String,
      correctAnswer: map['correctAnswer'] as String,
      fakeAnswer: map['fakeAnswer'] as String,
      chosenAnswer: map['chosenAnswer'] as String,
      isCorrect: map['isCorrect'] as bool,
      guesserUid: map['guesserUid'] as String? ?? '', // ✅ Add this
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'riddle': riddle,
      'correctAnswer': correctAnswer,
      'fakeAnswer': fakeAnswer,
      'chosenAnswer': chosenAnswer,
      'isCorrect': isCorrect,
      'guesserUid': guesserUid, // ✅ Save this to Firestore
    };
  }
}
