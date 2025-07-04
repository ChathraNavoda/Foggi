import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/streak_service.dart';

final memoryStreakProvider = FutureProvider<int>((ref) async {
  return await StreakService.getStreak();
});
