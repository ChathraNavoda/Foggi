import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/blocs/escape_the_fog/escape_the_fog_bloc.dart';
import '../../../../logic/blocs/escape_the_fog/escape_the_fog_event.dart';

class EscapeLevelSelectionScreen extends StatelessWidget {
  const EscapeLevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EscapeTheFogBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text("Select Level")),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, index) {
          final level = index + 1;
          final isUnlocked = level <= bloc.currentLevel;

          return ListTile(
            title: Text("Level $level"),
            trailing: isUnlocked
                ? const Icon(Icons.lock_open)
                : const Icon(Icons.lock),
            onTap: isUnlocked
                ? () {
                    bloc.currentLevel = level;
                    bloc.add(StartEscapeGame());
                    Navigator.pushNamed(context, '/escape-the-fog/game');
                  }
                : null,
          );
        },
      ),
    );
  }
}
