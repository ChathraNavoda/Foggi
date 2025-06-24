// lib/features/riddle/models/riddle.dart

class Riddle {
  final String question;
  final String answer;

  Riddle({required this.question, required this.answer});
}

// lib/features/riddle/data/riddle_repository.dart

class RiddleRepository {
  List<Riddle> getRiddles() {
    final riddles = [];
    riddles.shuffle();
    return [
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
    ];
  }
}
