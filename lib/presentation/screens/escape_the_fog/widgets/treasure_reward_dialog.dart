import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          onPressed: () async {
            final uid = FirebaseAuth.instance.currentUser!.uid;
            final chestCoins = 10; // number awarded

            final userRef =
                FirebaseFirestore.instance.collection('users').doc(uid);
            await userRef.update({
              'coins': FieldValue.increment(chestCoins),
              'chestHistory': FieldValue.arrayUnion([
                {
                  'coins': chestCoins,
                  'date': Timestamp.now(),
                  'source': 'EscapeTheFog'
                }
              ]),
            });
            Navigator.of(context).pop();
          },
          child: const Text("Awesome!"),
        ),
      ],
    );
  }
}
