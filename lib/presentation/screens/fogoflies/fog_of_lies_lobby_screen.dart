import 'package:flutter/material.dart';

class FogOfLiesLobbyScreen extends StatelessWidget {
  const FogOfLiesLobbyScreen({super.key});

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
              onPressed: () {
                // TODO: Add BLoC start and nav to game screen
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
