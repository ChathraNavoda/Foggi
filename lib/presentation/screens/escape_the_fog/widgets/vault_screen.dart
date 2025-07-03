import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    return Scaffold(
      appBar: AppBar(title: const Text("🏛️ My Vault")),
      body: FutureBuilder<DocumentSnapshot>(
        future: userRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text("Vault is empty."));
          }

          final coins = data['coins'] ?? 0;
          final history =
              List<Map<String, dynamic>>.from(data['chestHistory'] ?? []);

          history.sort((a, b) =>
              (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Vault Title and Coin Count
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6)
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text("💰 Total Fog Coins",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("$coins",
                          style: const TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Chest History Section
                if (history.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final entry = history[index];
                        final time = (entry['date'] as Timestamp).toDate();
                        final formatted =
                            DateFormat.yMMMEd().add_jm().format(time);
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Text("🧰",
                                style: TextStyle(fontSize: 24)),
                            title: Text("+${entry['coins']} coins"),
                            subtitle: Text("${entry['source']} • $formatted"),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Text("No treasures collected yet 🪙"),

                const SizedBox(height: 16),

                // Back to Home Button
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back to Home"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
