import 'package:flutter/material.dart';

import '../layout/foggi_scaffold.dart';
import '../widgets/custom_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FoggiScaffold(
      title: "Welcome to Foggi 👻",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader("Let's get foggy with it!"),
        ],
      ),
    );
  }
}
