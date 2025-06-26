// lib/features/leaderboard/widgets/leaderboard_section.dart
import 'package:flutter/material.dart';

import '../../../data/models/leaderboard_entry.dart';
import 'leaderboard_tile.dart';

class LeaderboardSection extends StatelessWidget {
  final String title;
  final List<LeaderboardEntry> entries;

  const LeaderboardSection({
    super.key,
    required this.title,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...entries.map((entry) => LeaderboardTile(entry: entry)),
          ],
        ),
      ),
    );
  }
}
