import 'package:flutter/material.dart';

class TreasureRewardDialog extends StatelessWidget {
  const TreasureRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text("🎁 Treasure Unlocked!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("✨ You earned:", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          ListTile(
            leading: Text("💰", style: TextStyle(fontSize: 24)),
            title: Text("100 Fog Coins"),
          ),
          ListTile(
            leading: Text("🔮", style: TextStyle(fontSize: 24)),
            title: Text("Orb of Clarity"),
          ),
          ListTile(
            leading: Text("📜", style: TextStyle(fontSize: 24)),
            title: Text("Secret Scroll (Power-up)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Awesome!"),
        ),
      ],
    );
  }
}
