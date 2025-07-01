import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EscapeTheFogLobbyScreen extends StatelessWidget {
  const EscapeTheFogLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escape the Fog"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Text(
              "🌀 Welcome to Escape the Fog!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "You're trapped in a mysterious foggy maze. Use the arrows to navigate your way out. But beware — one wrong turn, and you might be lost forever.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => context.go('/escape-the-fog/game'),
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Game"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
