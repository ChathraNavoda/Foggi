import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrialSelectorScreen extends StatefulWidget {
  const TrialSelectorScreen({super.key});

  @override
  State<TrialSelectorScreen> createState() => _TrialSelectorScreenState();
}

class _TrialSelectorScreenState extends State<TrialSelectorScreen> {
  int coins = 0;
  bool loading = true;
  final int trialCost = 5;

  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  Future<void> _fetchCoins() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      coins = doc['coins'] ?? 0;
      loading = false;
    });
  }

  Future<void> _enterTrial() async {
    if (coins < trialCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough Fog Coins to enter!")),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'coins': FieldValue.increment(-trialCost),
    });

    // Navigate to randomized trial
    final trials = ['/trials/memory']; // Add more later
    final selected = (trials..shuffle()).first;

    GoRouter.of(context).go(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🌀 Trials of the Unknown")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text("💰 Fog Coins",
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text("$coins",
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text("Face a random Trial of the Fog",
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _enterTrial,
                    icon: const Icon(Icons.local_fire_department),
                    label: Text("Enter Trial (-$trialCost coins)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => GoRouter.of(context).go('/vault'),
                    child: const Text("View My Vault"),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Daily trial coming soon...",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
    );
  }
}
