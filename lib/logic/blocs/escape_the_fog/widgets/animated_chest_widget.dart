// animated_chest_widget.dart

import 'package:flutter/material.dart';

class AnimatedChest extends StatefulWidget {
  final VoidCallback onOpened;

  const AnimatedChest({super.key, required this.onOpened});

  @override
  State<AnimatedChest> createState() => _AnimatedChestState();
}

class _AnimatedChestState extends State<AnimatedChest> {
  bool isOpen = false;

  void _handleTap() {
    if (!isOpen) {
      setState(() => isOpen = true);
      widget.onOpened(); // ✅ Notify parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        firstChild: Image.asset('assets/images/chest_closed.png', width: 120),
        secondChild: Image.asset('assets/images/chest_open.png', width: 120),
        crossFadeState:
            isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
    );
  }
}
