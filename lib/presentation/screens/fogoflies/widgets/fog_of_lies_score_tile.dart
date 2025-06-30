import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure to add intl to pubspec.yaml

class FogOfLiesScoreTile extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final int score;
  final dynamic date;

  const FogOfLiesScoreTile({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.score,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(date);

    return ListTile(
      leading: _buildAvatar(avatarUrl),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Played on $formattedDate"),
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

  String _formatDate(dynamic rawDate) {
    if (rawDate == null) return 'Unknown';

    try {
      // If it's already a DateTime (e.g. from Timestamp.toDate())
      if (rawDate is DateTime) {
        return DateFormat('MMM d, yyyy – h:mm a').format(rawDate);
      }

      // If it's a Firestore Timestamp
      if (rawDate is Timestamp) {
        return DateFormat('MMM d, yyyy – h:mm a').format(rawDate.toDate());
      }

      // If it's a string
      final parsed = DateTime.tryParse(rawDate.toString());
      if (parsed != null) {
        return DateFormat('MMM d, yyyy – h:mm a').format(parsed);
      }

      return 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }
}
