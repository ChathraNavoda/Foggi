import 'package:flutter/material.dart';

class AnimatedChest extends StatefulWidget {
  const AnimatedChest({super.key});
  @override
  State<AnimatedChest> createState() => _AnimatedChestState();
}

class _AnimatedChestState extends State<AnimatedChest> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isOpen = true),
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
