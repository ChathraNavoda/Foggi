import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/fogoflies/fog_of_lies_models.dart';

class FogOfLiesLobbyScreen extends StatelessWidget {
  const FogOfLiesLobbyScreen({super.key});

  Future<FogOfLiesPlayer> _getCurrentPlayer() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No logged-in user");

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data();
    if (data == null) throw Exception("User data not found");

    return FogOfLiesPlayer(
      uid: user.uid,
      name: data['displayName'] ?? 'Ghostling',
      avatar: data['avatar'] ?? '👻',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎭 Fog of Lies - Lobby"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ready to play Fog of Lies?",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final player = await _getCurrentPlayer();

                  // For now, use same player as both player1 and player2 (demo mode)
                  context.go(
                    '/fog_of_lies_game',
                    extra: {
                      'player1': player,
                      'player2': player,
                    },
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
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
