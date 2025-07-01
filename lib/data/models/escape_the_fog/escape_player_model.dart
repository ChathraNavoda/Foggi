class EscapePlayer {
  final String uid;
  final String name;
  final String avatar;

  EscapePlayer({
    required this.uid,
    required this.name,
    required this.avatar,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'avatar': avatar,
      };

  factory EscapePlayer.fromMap(Map<String, dynamic> map) => EscapePlayer(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        avatar: map['avatar'] ?? '',
      );
}
