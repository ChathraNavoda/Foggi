// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../../services/memory_streak_provider.dart';
// import '../../../services/streak_service.dart';
// import 'widgets/fog_overlay.dart';

// class MemoryInTheMistScreen extends ConsumerStatefulWidget {
//   const MemoryInTheMistScreen({super.key});

//   @override
//   ConsumerState<MemoryInTheMistScreen> createState() =>
//       _MemoryInTheMistScreenState();
// }

// class _MemoryInTheMistScreenState extends ConsumerState<MemoryInTheMistScreen> {
//   late List<_CardModel> cards;
//   _CardModel? firstSelected;
//   bool allowInteraction = false;
//   int matchesFound = 0;
//   int totalPairs = 4;
//   int currentLevel = 1;
//   bool fogBoosted = false;
//   bool showSecretMessage = false;
//   final List<String> secretMessages = [
//     "🧠 You remember now...",
//     "🔮 The truth is revealed...",
//     "✨ Your memory returns...",
//     "🌫️ The mist fades away...",
//     "👁️ What was hidden is now clear.",
//   ];

//   String revealedMessage = "";

//   final symbolPool = [
//     '🌫️',
//     '🔮',
//     '💀',
//     '🪞',
//     '🕯️',
//     '🗝️',
//     '🧩',
//     '🐺',
//     '👁️',
//     '🧠',
//     '🐉',
//     '📜',
//     '🪬',
//     '🦴',
//     '🕸️',
//     '🧪',
//     '🦉',
//     '🌕',
//     '🧿',
//     '🦇',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _setupLevel();
//   }

//   void _setupLevel() {
//     totalPairs = 2 + currentLevel;
//     matchesFound = 0;
//     firstSelected = null;
//     allowInteraction = false;
//     showSecretMessage = false;
//     revealedMessage = "";

//     _generateCards();

//     // Delay a frame to let the UI build before showing preview
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startPreview(); // 👉 show then hide cards
//     });
//   }

//   void _generateCards() {
//     final symbols = List<String>.from(symbolPool)..shuffle();
//     final chosen = symbols.take(totalPairs).toList();
//     final fullSet = [...chosen, ...chosen]..shuffle();

//     cards = List.generate(
//       fullSet.length,
//       (i) => _CardModel(symbol: fullSet[i], revealed: false, matched: false),
//     );
//   }

//   void _startPreview() async {
//     setState(() {
//       fogBoosted = true;
//       cards = cards.map((c) => c.copyWith(revealed: true)).toList();
//     });

//     await Future.delayed(const Duration(seconds: 2));

//     setState(() {
//       fogBoosted = false;
//       cards = cards.map((c) => c.copyWith(revealed: false)).toList();
//       allowInteraction = true;
//     });
//   }

//   void _onCardTap(int index) {
//     if (!allowInteraction || cards[index].revealed || cards[index].matched)
//       return;

//     setState(() {
//       cards[index] = cards[index].copyWith(revealed: true);
//     });

//     if (firstSelected == null) {
//       firstSelected = cards[index];
//     } else {
//       allowInteraction = false;
//       final second = cards[index];

//       if (firstSelected!.symbol == second.symbol) {
//         setState(() {
//           cards = cards.map((c) {
//             if (c.symbol == firstSelected!.symbol)
//               return c.copyWith(matched: true);
//             return c;
//           }).toList();
//         });

//         matchesFound++;

//         if (matchesFound == totalPairs) {
//           final random = (secretMessages..shuffle()).first;
//           setState(() {
//             revealedMessage = random;
//             showSecretMessage = true;
//           });

//           // ✅ Auto-hide message after 4 seconds
//           Future.delayed(const Duration(seconds: 3), () {
//             if (mounted) {
//               setState(() {
//                 showSecretMessage = false;
//               });
//             }
//           });

//           Future.delayed(const Duration(seconds: 2), _onLevelComplete);
//         } else {
//           allowInteraction = true;
//           firstSelected = null;
//         }
//       } else {
//         Future.delayed(const Duration(seconds: 1), () {
//           setState(() {
//             cards = cards.map((c) {
//               if (!c.matched) return c.copyWith(revealed: false);
//               return c;
//             }).toList();
//             allowInteraction = true;
//             firstSelected = null;
//           });
//         });
//       }
//     }
//   }

//   Future<void> _onLevelComplete() async {
//     final reward = 2 + currentLevel; // Reward increases by level
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     final newStreak = await StreakService.updateStreak();
//     if (newStreak == 3 || newStreak == 5 || newStreak == 7) {
//       await showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text("🎁 Streak Reward!"),
//           content: Text("You've reached a $newStreak-day streak!\n"
//               "Bonus: +$newStreak Fog Coins!"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Claim"),
//             ),
//           ],
//         ),
//       );

//       // Give bonus
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid != null) {
//         final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
//         await userRef.update({
//           'coins': FieldValue.increment(newStreak),
//           'chestHistory': FieldValue.arrayUnion([
//             {
//               'coins': newStreak,
//               'date': Timestamp.now(),
//               'source': 'StreakReward_$newStreak'
//             }
//           ]),
//         });
//       }
//     }

//     ref.invalidate(memoryStreakProvider);

//     if (uid != null) {
//       final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
//       await userRef.update({
//         'coins': FieldValue.increment(reward),
//         'chestHistory': FieldValue.arrayUnion([
//           {
//             'coins': reward,
//             'date': Timestamp.now(),
//             'source': 'MemoryInTheMist Lv$currentLevel'
//           }
//         ]),
//       });
//     }

//     await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("✅ Level Complete"),
//         content: Text(
//           "You earned $reward Fog Coins!\n"
//           "Level $currentLevel complete.\n"
//           "🔥 Streak: $newStreak days",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await StreakService.reset(); // 💥 Reset streak
//               ref.invalidate(memoryStreakProvider);
//               Navigator.of(context).pop();
//               GoRouter.of(context).go('/trials');
//             },
//             child: const Text("Exit", style: TextStyle(color: Colors.white)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               setState(() {
//                 currentLevel++;
//                 _setupLevel();
//               });
//             },
//             child: const Text("Next Level"),
//           ),
//         ],
//       ),
//     );
//     if (currentLevel == 18) {
//       await showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text("🏆 Final Treasure Unlocked!"),
//           content: const Text(
//               "You've conquered all memories in the mist.\nA secret relic is yours."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 GoRouter.of(context).go('/trials');
//               },
//               child: const Text("Return"),
//             ),
//           ],
//         ),
//       );
//       return; // Prevent going to next level
//     }
//   }

//   int _calculateCrossAxisCount() {
//     if (totalPairs <= 4) return 4;
//     if (totalPairs <= 6) return 5;
//     return 6;
//   }

//   double _calculateFogOpacity() {
//     if (fogBoosted) return 1.0;

//     final ratio = matchesFound / totalPairs;

//     // Start at 0.6 → fade to 0.0
//     return (1.0 - ratio) * 0.6;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final streak = ref.watch(memoryStreakProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text("🧠 Lv.$currentLevel"),
//             const SizedBox(width: 12),
//             streak.when(
//               data: (s) =>
//                   Text("🔥 Streak: $s", style: const TextStyle(fontSize: 14)),
//               loading: () => const Text("🔥 ..."),
//               error: (_, __) => const Text("🔥 ❓"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => GoRouter.of(context).go('/trials'),
//             child: const Text("Exit", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: GridView.builder(
//               itemCount: cards.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: _calculateCrossAxisCount(),
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//               ),
//               itemBuilder: (context, index) {
//                 final card = cards[index];
//                 return GestureDetector(
//                   onTap: () => _onCardTap(index),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     decoration: BoxDecoration(
//                       color: card.revealed || card.matched
//                           ? Colors.white
//                           : Colors.deepPurple.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: card.revealed
//                           ? [BoxShadow(color: Colors.black26, blurRadius: 4)]
//                           : [],
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       card.revealed || card.matched ? card.symbol : '❓',
//                       style: const TextStyle(fontSize: 24),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           FogOverlay(opacity: _calculateFogOpacity()),
//           if (showSecretMessage)
//             Center(
//               child: AnimatedOpacity(
//                 duration: const Duration(milliseconds: 1000),
//                 opacity: 1,
//                 child: Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.black87.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Text(
//                     revealedMessage,
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: Colors.white,
//                       fontStyle: FontStyle.italic,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _CardModel {
//   final String symbol;
//   final bool revealed;
//   final bool matched;

//   _CardModel({
//     required this.symbol,
//     this.revealed = false,
//     this.matched = false,
//   });

//   _CardModel copyWith({bool? revealed, bool? matched}) {
//     return _CardModel(
//       symbol: symbol,
//       revealed: revealed ?? this.revealed,
//       matched: matched ?? this.matched,
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/memory_streak_provider.dart';
import '../../../services/streak_service.dart';
import 'widgets/fog_overlay.dart';

class MemoryInTheMistScreen extends ConsumerStatefulWidget {
  const MemoryInTheMistScreen({super.key});

  @override
  ConsumerState<MemoryInTheMistScreen> createState() =>
      _MemoryInTheMistScreenState();
}

class _MemoryInTheMistScreenState extends ConsumerState<MemoryInTheMistScreen> {
  late List<_CardModel> cards;
  _CardModel? firstSelected;
  bool allowInteraction = false;
  int matchesFound = 0;
  int totalPairs = 4;
  int currentLevel = 1;
  bool fogBoosted = false;
  bool showSecretMessage = false;
  final List<String> secretMessages = [
    "🧠 You remember now...",
    "🔮 The truth is revealed...",
    "✨ Your memory returns...",
    "🌫️ The mist fades away...",
    "🕁️ What was hidden is now clear.",
  ];

  String revealedMessage = "";

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
    '🐉',
    '📜',
    '🪬',
    '🦴',
    '🕸️',
    '🧪',
    '🦉',
    '🌕',
    '🧿',
    '🦇'
  ];

  @override
  void initState() {
    super.initState();
    _setupLevel();
  }

  void _setupLevel() {
    totalPairs = 2 + currentLevel;
    matchesFound = 0;
    firstSelected = null;
    allowInteraction = false;
    showSecretMessage = false;
    revealedMessage = "";

    _generateCards();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPreview();
    });
  }

  void _generateCards() {
    final symbols = List<String>.from(symbolPool)..shuffle();
    if (totalPairs > symbols.length) {
      totalPairs = symbols.length; // Safety cap
    }

    final chosen = symbols.take(totalPairs).toList();
    final fullSet = [...chosen, ...chosen]..shuffle();

    cards = List.generate(
      fullSet.length,
      (i) => _CardModel(symbol: fullSet[i], revealed: false, matched: false),
    );
  }

  void _startPreview() async {
    setState(() {
      fogBoosted = true;
      cards = cards.map((c) => c.copyWith(revealed: true)).toList();
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      fogBoosted = false;
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
          final random = (secretMessages..shuffle()).first;
          setState(() {
            revealedMessage = random;
            showSecretMessage = true;
          });

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                showSecretMessage = false;
              });
            }
          });

          Future.delayed(const Duration(seconds: 2), _onLevelComplete);
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
    final reward = 2 + currentLevel;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final newStreak = await StreakService.updateStreak();

    if (newStreak == 3 || newStreak == 5 || newStreak == 7) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🎁 Streak Reward!"),
          content: Text(
              "You've reached a $newStreak-day streak!\nBonus: +$newStreak Fog Coins!"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Claim"))
          ],
        ),
      );

      if (uid != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
        await userRef.update({
          'coins': FieldValue.increment(newStreak),
          'chestHistory': FieldValue.arrayUnion([
            {
              'coins': newStreak,
              'date': Timestamp.now(),
              'source': 'StreakReward_$newStreak'
            }
          ])
        });
      }
    }

    ref.invalidate(memoryStreakProvider);

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
        ])
      });
    }

    if (currentLevel == 18) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🏆 Final Treasure Unlocked!"),
          content: const Text(
              "You've conquered all memories in the mist. A secret relic is yours."),
          actions: [
            TextButton(
                onPressed: () => GoRouter.of(context).go('/trials'),
                child: const Text("Return"))
          ],
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✅ Level Complete"),
        content: Text(
            "You earned $reward Fog Coins!\nLevel $currentLevel complete.\n🔥 Streak: $newStreak days"),
        actions: [
          TextButton(
            onPressed: () async {
              await StreakService.reset();
              ref.invalidate(memoryStreakProvider);
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
          )
        ],
      ),
    );
  }

  double _calculateFogOpacity() {
    if (fogBoosted) return 1.0;
    final ratio = matchesFound / totalPairs;
    return (1.0 - ratio) * 0.6;
  }

  @override
  Widget build(BuildContext context) {
    final streak = ref.watch(memoryStreakProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("🧠 Lv.$currentLevel"),
            const SizedBox(width: 12),
            streak.when(
              data: (s) =>
                  Text("🔥 Streak: $s", style: const TextStyle(fontSize: 14)),
              loading: () => const Text("🔥 ..."),
              error: (_, __) => const Text("🔥 ❓"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).go('/trials'),
            child: const Text("Exit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cardCount = cards.length;
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              // Try to find best grid (cols x rows) that fits all cards
              int optimalCrossAxisCount = 2;
              double cardSize = 0;
              for (int cols = 2; cols <= 6; cols++) {
                final rows = (cardCount / cols).ceil();
                final spacing = 12.0 * (cols - 1);
                final totalCardWidth =
                    screenWidth - spacing - 32; // 16px padding both sides
                final totalCardHeight =
                    screenHeight - spacing - 32 - kToolbarHeight;

                final maxCardWidth = totalCardWidth / cols;
                final maxCardHeight = totalCardHeight / rows;

                final size =
                    maxCardWidth < maxCardHeight ? maxCardWidth : maxCardHeight;

                if (size >= 40) {
                  optimalCrossAxisCount = cols;
                  cardSize = size;
                }
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // ❌ no scrolling
                  itemCount: cards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: optimalCrossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return GestureDetector(
                      onTap: () => _onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: cardSize,
                        height: cardSize,
                        decoration: BoxDecoration(
                          color: card.revealed || card.matched
                              ? Colors.white
                              : Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: card.revealed
                              ? [
                                  BoxShadow(
                                      color: Colors.black26, blurRadius: 4)
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              8.0), // 👈 Add padding around emoji
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              card.revealed || card.matched ? card.symbol : '❓',
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          FogOverlay(opacity: _calculateFogOpacity()),
          if (showSecretMessage)
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: 1,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    revealedMessage,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CardModel {
  final String symbol;
  final bool revealed;
  final bool matched;

  _CardModel(
      {required this.symbol, this.revealed = false, this.matched = false});

  _CardModel copyWith({bool? revealed, bool? matched}) {
    return _CardModel(
      symbol: symbol,
      revealed: revealed ?? this.revealed,
      matched: matched ?? this.matched,
    );
  }
}
