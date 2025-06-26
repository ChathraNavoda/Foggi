import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foggi/data/models/leaderboard_entry.dart';
import 'package:foggi/logic/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:foggi/logic/blocs/leaderboard/leaderboard_event.dart';
import 'package:foggi/logic/blocs/leaderboard/leaderboard_state.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/leaderboard/leaderboard_section.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👑 Leaderboard"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            LeaderboardBloc(firestore: FirebaseFirestore.instance)
              ..add(LoadLeaderboard()),
        child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LeaderboardLoaded) {
              final bestScores = state.entries
                  .fold<Map<String, LeaderboardEntry>>({}, (map, entry) {
                    if (!map.containsKey(entry.uid) ||
                        entry.score > map[entry.uid]!.score) {
                      map[entry.uid] = entry;
                    }
                    return map;
                  })
                  .values
                  .toList()
                ..sort((a, b) => b.score.compareTo(a.score));

              final allScores = [...state.entries]
                ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🏆 Top Scores (Best of All Time)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LeaderboardSection(
                        title: "Top Scores",
                        entries: bestScores,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "📜 Game History (All Attempts)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LeaderboardSection(
                        title: "Game History",
                        entries: allScores,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is LeaderboardError) {
              return Center(
                child: Text("🚫 ${state.message}"),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
