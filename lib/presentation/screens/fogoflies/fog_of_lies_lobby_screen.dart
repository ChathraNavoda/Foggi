import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/fogoflies/fog_of_lies_models.dart';

class FogOfLiesLobbyScreen extends StatefulWidget {
  const FogOfLiesLobbyScreen({super.key});

  @override
  State<FogOfLiesLobbyScreen> createState() => _FogOfLiesLobbyScreenState();
}

class _FogOfLiesLobbyScreenState extends State<FogOfLiesLobbyScreen> {
  bool _searching = false;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _opponentSub;
  Timer? _timeoutTimer;

  @override
  void dispose() {
    _opponentSub?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _startMatchmaking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final myPlayer = FogOfLiesPlayer(
      uid: user.uid,
      name: user.displayName ?? 'Anonymous',
      avatar: '🤖',
    );

    print(
        "🔍 [Lobby] Searching for opponent as ${myPlayer.name} (${myPlayer.uid})");

    final matchmakingRef = FirebaseFirestore.instance.collection('matchmaking');

    final opponentQuery = await matchmakingRef
        .where('status', isEqualTo: 'waiting')
        .where('uid', isNotEqualTo: myPlayer.uid)
        .orderBy('timestamp', descending: false)
        .limit(1)
        .get();

    if (opponentQuery.docs.isNotEmpty) {
      final opponentDoc = opponentQuery.docs.first;
      final opponent = FogOfLiesPlayer(
        uid: opponentDoc['uid'],
        name: opponentDoc['displayName'],
        avatar: opponentDoc['avatar'],
      );

      print("🎯 [Lobby] Found opponent: ${opponent.name} (${opponent.uid})");

      final gameId =
          'fog_${opponent.uid}_${myPlayer.uid}_${DateTime.now().millisecondsSinceEpoch}';

      await matchmakingRef.doc(opponentDoc.id).update({
        'status': 'matched',
        'opponent': {
          'uid': myPlayer.uid,
          'displayName': myPlayer.name,
          'avatar': myPlayer.avatar,
        },
        'gameId': gameId, // ✅ Store gameId in Firestore
      });

      if (!mounted) return;

      print("🚀 [Lobby] Launching game with gameId: $gameId");
      context.go('/fog_of_lies_game', extra: {
        'player1': opponent,
        'player2': myPlayer,
        'gameId': gameId,
      });

      return;
    }

    print("👤 [Lobby] No opponent found. Adding self to matchmaking...");

    final myDoc = await matchmakingRef.add({
      'uid': myPlayer.uid,
      'displayName': myPlayer.name,
      'avatar': myPlayer.avatar,
      'status': 'waiting',
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => _searching = true);

    _opponentSub = myDoc.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      print("📡 [Lobby] Update received: ${data?['status']}");

      if (snapshot.exists && data != null && data['status'] == 'matched') {
        final rawOpponent = data['opponent'];
        final gameId = data['gameId'] as String?;

        if (rawOpponent is! Map<String, dynamic> || gameId == null) {
          print("❌ [Lobby] Invalid match data: $data");
          return;
        }

        final opponent = FogOfLiesPlayer(
          uid: rawOpponent['uid'],
          name: rawOpponent['displayName'],
          avatar: rawOpponent['avatar'],
        );

        print(
            "🎯 [Lobby] Match successful! Opponent: ${opponent.name} (${opponent.uid})");
        print("🚀 [Lobby] Using shared gameId: $gameId");

        _timeoutTimer?.cancel();

        if (!mounted) return;

        context.go('/fog_of_lies_game', extra: {
          'player1': myPlayer,
          'player2': opponent,
          'gameId': gameId,
        });
      }
    });

    _timeoutTimer = Timer(const Duration(seconds: 20), () async {
      print("⌛ [Lobby] Timeout reached. Checking if still unmatched...");

      final snapshot = await myDoc.get();
      final data = snapshot.data();

      // 🛑 If already matched by someone else, do nothing
      if (data != null && data['status'] == 'matched') {
        print("✅ [Lobby] Already matched, skipping bot fallback.");
        return;
      }

      print("🤖 [Lobby] No match found. Spawning bot...");

      final fakeBot = FogOfLiesPlayer(
        uid: 'bot_${myPlayer.uid}',
        name: 'FogBot',
        avatar: '🤖',
      );

      final gameId =
          'fog_${myPlayer.uid}_bot_${DateTime.now().millisecondsSinceEpoch}';

      await myDoc.update({
        'status': 'matched',
        'opponent': {
          'uid': fakeBot.uid,
          'displayName': fakeBot.name,
          'avatar': fakeBot.avatar,
        },
        'gameId': gameId, // ✅ Save the game ID
      });

      if (!mounted) return;

      print("🚀 [Lobby] Launching game with bot. gameId: $gameId");

      context.go('/fog_of_lies_game', extra: {
        'player1': myPlayer,
        'player2': fakeBot,
        'gameId': gameId,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎭 Fog of Lies - Lobby')),
      body: Center(
        child: _searching
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Searching for opponent..."),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Ready to play Fog of Lies?",
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _startMatchmaking,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Find Opponent"),
                  ),
                ],
              ),
      ),
    );
  }
}
