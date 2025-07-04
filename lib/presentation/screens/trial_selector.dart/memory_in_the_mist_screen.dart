import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemoryInTheMistScreen extends StatefulWidget {
  const MemoryInTheMistScreen({super.key});

  @override
  State<MemoryInTheMistScreen> createState() => _MemoryInTheMistScreenState();
}

class _MemoryInTheMistScreenState extends State<MemoryInTheMistScreen> {
  late List<_CardModel> cards;
  _CardModel? firstSelected;
  bool allowInteraction = false;
  int matchesFound = 0;
  int totalPairs = 4;
  int currentLevel = 1;

  final symbolPool = [
    '🌫️',
    '🔮',
    '💀',
    '🪞',
    '🕯️',
    '🗝️',
    '🧩',
    '🐺',
    '👁️',
    '🧠',
    '🐉'
  ];

  @override
  void initState() {
    super.initState();
    _setupLevel();
  }

  void _setupLevel() {
    totalPairs = 2 + currentLevel; // Level 1 = 3 pairs, Level 2 = 4 pairs, etc.
    matchesFound = 0;
    firstSelected = null;
    allowInteraction = false;
    _generateCards();
    _startGame();
  }

  void _generateCards() {
    final symbols = List<String>.from(symbolPool)..shuffle();
    final chosen = symbols.take(totalPairs).toList();
    final fullSet = [...chosen, ...chosen]..shuffle();

    cards = List.generate(
      fullSet.length,
      (i) => _CardModel(symbol: fullSet[i], revealed: false, matched: false),
    );
  }

  void _startGame() async {
    setState(() {
      cards = cards.map((c) => c.copyWith(revealed: true)).toList();
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      cards = cards.map((c) => c.copyWith(revealed: false)).toList();
      allowInteraction = true;
    });
  }

  void _onCardTap(int index) {
    if (!allowInteraction || cards[index].revealed || cards[index].matched)
      return;

    setState(() {
      cards[index] = cards[index].copyWith(revealed: true);
    });

    if (firstSelected == null) {
      firstSelected = cards[index];
    } else {
      allowInteraction = false;
      final second = cards[index];

      if (firstSelected!.symbol == second.symbol) {
        setState(() {
          cards = cards.map((c) {
            if (c.symbol == firstSelected!.symbol)
              return c.copyWith(matched: true);
            return c;
          }).toList();
        });
        matchesFound++;
        if (matchesFound == totalPairs) {
          _onLevelComplete();
        } else {
          allowInteraction = true;
          firstSelected = null;
        }
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            cards = cards.map((c) {
              if (!c.matched) return c.copyWith(revealed: false);
              return c;
            }).toList();
            allowInteraction = true;
            firstSelected = null;
          });
        });
      }
    }
  }

  Future<void> _onLevelComplete() async {
    final reward = 2 + currentLevel; // Reward increases by level
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.update({
        'coins': FieldValue.increment(reward),
        'chestHistory': FieldValue.arrayUnion([
          {
            'coins': reward,
            'date': Timestamp.now(),
            'source': 'MemoryInTheMist Lv$currentLevel'
          }
        ]),
      });
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✅ Level Complete"),
        content: Text(
            "You earned $reward Fog Coins!\nLevel $currentLevel complete."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              GoRouter.of(context).go('/trials');
            },
            child: const Text("Exit"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentLevel++;
                _setupLevel();
              });
            },
            child: const Text("Next Level"),
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount() {
    if (totalPairs <= 4) return 4;
    if (totalPairs <= 6) return 5;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🧠 Memory in the Mist — Lv.$currentLevel"),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).go('/trials'),
            child: const Text("Exit", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];
            return GestureDetector(
              onTap: () => _onCardTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: card.revealed || card.matched
                      ? Colors.white
                      : Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: card.revealed
                      ? [BoxShadow(color: Colors.black26, blurRadius: 4)]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  card.revealed || card.matched ? card.symbol : '❓',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CardModel {
  final String symbol;
  final bool revealed;
  final bool matched;

  _CardModel({
    required this.symbol,
    this.revealed = false,
    this.matched = false,
  });

  _CardModel copyWith({bool? revealed, bool? matched}) {
    return _CardModel(
      symbol: symbol,
      revealed: revealed ?? this.revealed,
      matched: matched ?? this.matched,
    );
  }
}
