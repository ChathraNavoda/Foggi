// lib/features/riddle/models/riddle.dart

import 'dart:math';

class Riddle {
  final String question;
  final String answer;

  Riddle({required this.question, required this.answer});
}

class RiddleRepository {
  final List<Riddle> _riddleBank = [
    Riddle(
      question:
          "I speak without a mouth and hear without ears. I have nobody, but I come alive with the wind. What am I?",
      answer: "Echo",
    ),
    Riddle(
      question:
          "The more of me you take, the more you leave behind. What am I?",
      answer: "Footsteps",
    ),
    Riddle(
      question:
          "What can travel around the world while staying in the same corner?",
      answer: "Stamp",
    ),
    Riddle(
      question:
          "I’m tall when I’m young, and I’m short when I’m old. What am I?",
      answer: "Candle",
    ),
    Riddle(
      question: "What has to be broken before you can use it?",
      answer: "Egg",
    ),
    Riddle(
      question:
          "I have keys but no locks. I have space but no room. You can enter, but can’t go outside. What am I?",
      answer: "Keyboard",
    ),
    Riddle(
      question: "What gets bigger the more you take away?",
      answer: "Hole",
    ),
    Riddle(
      question:
          "I’m not alive, but I grow. I don’t have lungs, but I need air. What am I?",
      answer: "Fire",
    ),
    Riddle(
      question: "What invention lets you look right through a wall?",
      answer: "Window",
    ),
    Riddle(
      question:
          "What comes once in a minute, twice in a moment, but never in a thousand years?",
      answer: "The letter M",
    ),
    Riddle(
      question: "What has a heart that doesn’t beat?",
      answer: "Artichoke",
    ),
    Riddle(
      question:
          "What can run but never walks, has a bed but never sleeps, and has a mouth but never talks?",
      answer: "River",
    ),
    Riddle(
      question: "What kind of room has no doors or windows?",
      answer: "Mushroom",
    ),
    Riddle(
      question: "I shave every day, but my beard stays the same. Who am I?",
      answer: "Barber",
    ),
    Riddle(
      question: "I come down but never go up. What am I?",
      answer: "Rain",
    ),
    Riddle(
      question: "What has 13 hearts, but no other organs?",
      answer: "Deck of cards",
    ),
    Riddle(
      question: "If two’s company and three’s a crowd, what are four and five?",
      answer: "Nine",
    ),
    Riddle(
      question: "What can you catch, but not throw?",
      answer: "Cold",
    ),
    Riddle(
      question: "What has four wheels and flies?",
      answer: "Garbage truck",
    ),
    Riddle(
      question: "What’s full of holes but still holds water?",
      answer: "Sponge",
    ),
    Riddle(
      question: "What has one head, one foot, and four legs?",
      answer: "Bed",
    ),
    Riddle(
      question: "What is so fragile that saying its name breaks it?",
      answer: "Silence",
    ),
    Riddle(
      question: "What has words but never speaks?",
      answer: "Book",
    ),
  ];

  List<Riddle> getRiddles({int count = 5}) {
    final random = Random();
    final shuffled = List<Riddle>.from(_riddleBank)..shuffle(random);
    return shuffled.take(count).toList();
  }
}
