import 'package:flutter/material.dart';

class FoggiScaffold extends StatelessWidget {
  final Widget child;
  const FoggiScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foggi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
