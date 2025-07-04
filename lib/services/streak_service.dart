import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const _lastPlayKey = 'memory_last_play';
  static const _streakKey = 'memory_streak_count';

  static final _formatter = DateFormat('yyyy-MM-dd');

  /// Call this at end of game
  static Future<int> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _formatter.format(DateTime.now());
    final last = prefs.getString(_lastPlayKey);
    final currentStreak = prefs.getInt(_streakKey) ?? 0;

    if (last == today) {
      // Already played today
      return currentStreak;
    }

    final yesterday =
        _formatter.format(DateTime.now().subtract(const Duration(days: 1)));

    final newStreak = (last == yesterday) ? currentStreak + 1 : 1;

    await prefs.setString(_lastPlayKey, today);
    await prefs.setInt(_streakKey, newStreak);

    return newStreak;
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_streakKey);
    await prefs.remove(_lastPlayKey);
  }
}
