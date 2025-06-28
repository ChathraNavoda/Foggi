import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/fogoflies/fog_of_lies_models.dart';

class FogOfLiesLobbyScreen extends StatelessWidget {
  const FogOfLiesLobbyScreen({super.key});

  Future<FogOfLiesPlayer?> _getOpponent(String myUid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: myUid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final data = snapshot.docs.first;
    return FogOfLiesPlayer(
      uid: data.id,
      name: data['displayName'] ?? '???',
      avatar: data['avatar'] ?? '👻',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎭 Fog of Lies - Lobby")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ready to play Fog of Lies?",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final player1 = FogOfLiesPlayer(
                  uid: user.uid,
                  name: user.displayName ?? 'Anonymous',
                  avatar: '🤖', // Or fetch from Firestore if needed
                );

                final opponent = await _getOpponent(user.uid);
                if (opponent == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "No opponent found. You need another user to play.")),
                  );
                  return;
                }

                context.go(
                  '/fog_of_lies_game',
                  extra: {
                    'player1': player1,
                    'player2': opponent,
                  },
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Game"),
            )
          ],
        ),
      ),
    );
  }
}
