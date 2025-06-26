// import 'package:flutter/material.dart';

// import '../layout/foggi_scaffold.dart';
// import '../widgets/custom_header.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const FoggiScaffold(
//       title: "Welcome to Foggi 👻",
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomHeader("Let's get foggy with it!"),
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/button_styles.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_event.dart';
import '../layout/foggi_scaffold.dart';
import '../widgets/custom_header.dart';
import '../widgets/prompt_display_name.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("👻 The ghost has left the game..."),
        backgroundColor: Colors.deepPurpleAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final shouldPrompt = ref.watch(displayNamePromptProvider);
    final shouldPrompt = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      print("✅ Showing name prompt for user: ${user?.uid}");

      if (shouldPrompt && user != null && (user.displayName?.isEmpty ?? true)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => PromptDisplayNameDialog(),
        );
      }
    });

    return FoggiScaffold(
      title: "Welcome to Foggi 👻",
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader("Let's get foggy with it!"),
                const SizedBox(height: 28),
                Center(
                  child: ElevatedButton(
                    style: AppButtonStyles.startButton(context),
                    onPressed: () => context.go('/riddle'),
                    child: const Text("👻 Play Foggi Riddle Rush"),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () => _logout(context),
              style: AppButtonStyles.logoutButton(context),
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
