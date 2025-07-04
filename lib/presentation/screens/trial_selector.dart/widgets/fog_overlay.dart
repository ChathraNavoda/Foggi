import 'package:flutter/material.dart';

class FogOverlay extends StatelessWidget {
  final double opacity;

  const FogOverlay({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        opacity: opacity,
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.deepPurple.shade100.withOpacity(0.4),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
