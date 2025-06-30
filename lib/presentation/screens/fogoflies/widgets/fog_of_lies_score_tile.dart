import 'package:flutter/material.dart';

class FogOfLiesScoreTile extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final int score;
  final String date;

  const FogOfLiesScoreTile({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.score,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildAvatar(avatarUrl),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Played on $date"),
      trailing: Text("$score pts",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              )),
    );
  }

  Widget _buildAvatar(String avatarUrl) {
    final isValidUrl = Uri.tryParse(avatarUrl)?.hasAbsolutePath == true;
    return isValidUrl
        ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
        : CircleAvatar(child: Text(avatarUrl));
  }
}
