import 'package:flutter/material.dart';

import '../../../services/fog_of_lies_leaderboard_service.dart';
import 'widgets/fog_of_lies_score_tile.dart';

class FogOfLiesLeaderboardScreen extends StatefulWidget {
  const FogOfLiesLeaderboardScreen({super.key});

  @override
  State<FogOfLiesLeaderboardScreen> createState() =>
      _FogOfLiesLeaderboardScreenState();
}

class _FogOfLiesLeaderboardScreenState extends State<FogOfLiesLeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Map<String, dynamic>>> _topPlayersFuture;
  late Future<List<Map<String, dynamic>>> _gameHistoryFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    _topPlayersFuture = _fetchTopPlayers();
    _gameHistoryFuture = _fetchGameHistory();
  }

  final _leaderboardService = FogOfLiesLeaderboardService();

  Future<List<Map<String, dynamic>>> _fetchTopPlayers() =>
      _leaderboardService.getTopScores();

  Future<List<Map<String, dynamic>>> _fetchGameHistory() =>
      _leaderboardService.getAllHistory();

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fog of Lies Leaderboard'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.emoji_events), text: 'Top Players'),
              Tab(icon: Icon(Icons.history), text: 'Game History'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _topPlayersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data ?? [];
                  if (data.isEmpty) {
                    return const Center(
                        child: Text("No leaderboard data yet."));
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final user = data[index];
                      return FogOfLiesScoreTile(
                        name: user['displayName'] ?? 'Anonymous',
                        avatarUrl: user['avatar'] ?? '',
                        score: user['score'] ?? 0,
                        date: '',
                      );
                    },
                  );
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _gameHistoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data ?? [];
                  if (data.isEmpty) {
                    return const Center(child: Text("No game history yet."));
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final game = data[index];
                      final date = DateTime.tryParse(game['date'] ?? '');
                      return FogOfLiesScoreTile(
                        name: game['displayName'] ?? 'Player',
                        avatarUrl: game['avatar'] ?? '',
                        score: game['score'] ?? 0,
                        date: date != null
                            ? '${date.toLocal()}'.split('.').first
                            : 'Unknown',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
