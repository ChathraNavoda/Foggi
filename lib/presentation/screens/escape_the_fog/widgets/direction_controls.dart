import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foggi/logic/blocs/escape_the_fog/escape_the_fog_event.dart';

import '../../../../../logic/blocs/escape_the_fog/escape_the_fog_bloc.dart';

class DirectionControls extends StatelessWidget {
  const DirectionControls({super.key});

  void _move(BuildContext context, String dir) {
    context.read<EscapeTheFogBloc>().add(SubmitPlayerMove(dir));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up, size: 32),
          onPressed: () => _move(context, 'up'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_left, size: 32),
              onPressed: () => _move(context, 'left'),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_right, size: 32),
              onPressed: () => _move(context, 'right'),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => _move(context, 'down'),
        ),
      ],
    );
  }
}
