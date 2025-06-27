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
import '../../logic/blocs/auth/auth_state.dart';
import '../layout/foggi_scaffold.dart';
import '../widgets/custom_header.dart';
import '../widgets/prompt_display_name.dart';
import '../widgets/user_avatar_name_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context, WidgetRef ref) {
    context.read<AuthBloc>().add(AuthLogoutRequested());

    // ✅ Clear Riverpod state
    ref.invalidate(displayNamePromptProvider);
    ref.invalidate(selectedAvatarProvider);
    ref.invalidate(userProfileProvider);

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
    print('🔄 HomeScreen build() triggered');

    final shouldPrompt = ref.watch(displayNamePromptProvider);
    final user = FirebaseAuth.instance.currentUser;

    // ✅ SAFELY schedule prompt flag if displayName is missing
    if (user != null && (user.displayName?.isEmpty ?? true) && !shouldPrompt) {
      print("⚡️ No display name, scheduling prompt...");
      Future.microtask(() {
        ref.read(displayNamePromptProvider.notifier).state = true;
      });
    }

    // ✅ Listen to displayNamePromptProvider
    ref.listen<bool>(displayNamePromptProvider, (prev, next) async {
      print("👂 displayNamePromptProvider changed: $next");
      final user = FirebaseAuth.instance.currentUser;

      if (next == true && user != null && (user.displayName?.isEmpty ?? true)) {
        print("🧙 Showing display name prompt dialog...");
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const PromptDisplayNameDialog(),
        );
      }
    });

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null && (user.displayName?.isEmpty ?? true)) {
            print("✅ Authenticated but no display name — prompting...");
            ref.read(displayNamePromptProvider.notifier).state = true;
          }
        }
      },
      child: FoggiScaffold(
        title: "Welcome to Foggi 👻",
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader("Let's get foggy with it!"),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: UserAvatarNameBadge(),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: ElevatedButton(
                      style: AppButtonStyles.startButton(context),
                      onPressed: () => context.go('/riddle'),
                      child: const Text("👻 Play Foggi Riddle Rush"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      style: AppButtonStyles.startButton(context),
                      onPressed: () => context.go('/leaderboard'),
                      child: const Text("📊 View Leaderboard"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/fog-of-lies'),
                    child: const Text('🎭 Fog of Lies'),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: ElevatedButton(
                onPressed: () => _logout(context, ref),
                style: AppButtonStyles.logoutButton(context),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
