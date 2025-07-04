// // router.dart
// import 'dart:async';

// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../logic/blocs/auth/auth_bloc.dart';
// import '../logic/blocs/auth/auth_state.dart';
// import '../presentation/screens/auth/login_screen.dart';
// import '../presentation/screens/auth/register_screen.dart';
// import '../presentation/screens/home_screen.dart';
// import '../presentation/screens/splash_screen.dart';

// final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
//   return GlobalKey<NavigatorState>();
// });

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     notifyListeners();
//     _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
//   }

//   late final StreamSubscription<dynamic> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// final routerProvider = Provider<GoRouter>((ref) {
//   final authBloc = ref.watch(authBlocProvider);
//   final authState = authBloc.state;
//   final navigatorKey = ref.watch(navigatorKeyProvider);

//   return GoRouter(
//     navigatorKey: navigatorKey,
//     initialLocation: '/',
//     refreshListenable: GoRouterRefreshStream(authBloc.stream), // ✅ Add this!
//     redirect: (context, state) {
//       final isLoggedIn = authState is AuthAuthenticated;
//       final isLoggingIn = state.matchedLocation == '/login' ||
//           state.matchedLocation == '/register';

//       if (!isLoggedIn && state.matchedLocation == '/home') return '/login';
//       if (isLoggedIn && isLoggingIn) return '/home';
//       return null;
//     },
//     routes: [
//       GoRoute(path: '/', builder: (_, __) => const AnimatedSplashScreen()),
//       GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
//       GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
//       GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
//     ],
//   );
// });import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/fogoflies/fog_of_lies_models.dart';
import '../data/models/riddle.dart';
import '../data/models/riddle_results.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_state.dart';
import '../logic/blocs/escape_the_fog/escape_the_fog_bloc.dart';
import '../logic/blocs/fogoflies/fog_of_lies_bloc.dart';
import '../logic/blocs/fogoflies/fog_of_lies_event.dart';
import '../logic/blocs/riddle/riddle_game_bloc.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/escape_the_fog/escape_the_fog_game_screen.dart';
import '../presentation/screens/escape_the_fog/escape_the_fog_lobby_screen.dart';
import '../presentation/screens/escape_the_fog/widgets/vault_screen.dart';
import '../presentation/screens/fogoflies/fog_of_lies_game_screen.dart';
import '../presentation/screens/fogoflies/fog_of_lies_leaderboard_screen.dart';
import '../presentation/screens/fogoflies/fog_of_lies_lobby_screen.dart';
import '../presentation/screens/fogoflies/fog_of_lies_review_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/leaderboard/leaderboard_screen.dart';
import '../presentation/screens/riddle/riddle_review_screen.dart';
import '../presentation/screens/riddle/riddle_screen.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/trial_selector.dart/memory_in_the_mist_screen.dart';
import '../presentation/screens/trial_selector.dart/trial_selector_screen.dart';
import 'router_helper.dart';

/// Global navigator key used by GoRouter
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

/// Provide the AuthBloc from context (injected from main.dart)
final authBlocProvider = Provider<AuthBloc>((ref) {
  throw UnimplementedError('AuthBloc must be overridden in main.dart');
});

/// Notifier to help GoRouter listen for AuthBloc changes
class GoRouterRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription _sub;

  GoRouterRefreshNotifier(AuthBloc bloc) {
    _sub = bloc.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// Provide the notifier as a Riverpod provider
final routerRefreshProvider = Provider<GoRouterRefreshNotifier>((ref) {
  final bloc = ref.watch(authBlocProvider);
  final notifier = GoRouterRefreshNotifier(bloc);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

/// The actual GoRouter provider
final routerProvider = Provider<GoRouter>((ref) {
  final authBloc = ref.watch(authBlocProvider);
  final navigatorKey = ref.watch(navigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream), // ✅ no error now
    // 👈 crucial!
    redirect: (context, state) {
      final authState = authBloc.state;

      print(
          "🔄 Redirecting. Auth state: $authState, location: ${state.matchedLocation}");

      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && state.matchedLocation == '/home') return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const AnimatedSplashScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: '/riddle',
        builder: (context, state) => BlocProvider(
          create: (_) => RiddleGameBloc(riddleRepository: RiddleRepository()),
          child: const RiddleGameScreen(),
        ),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (_, __) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) {
          final results = state.extra as List<RiddleResult>;
          return RiddleReviewScreen(results: results);
        },
      ),
      GoRoute(
        path: '/fog-of-lies',
        builder: (_, __) => const FogOfLiesLobbyScreen(),
      ),
      GoRoute(
        path: '/fog_of_lies_game',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          if (extra == null ||
              extra['player1'] == null ||
              extra['player2'] == null ||
              extra['gameId'] == null) {
            print(
                "❌ ERROR: Missing required extra data in /fog_of_lies_game route: $extra");
            return const Scaffold(
              body: Center(child: Text('Missing game data')),
            );
          }

          final player1 = extra['player1'] as FogOfLiesPlayer;
          final player2 = extra['player2'] as FogOfLiesPlayer;
          final gameId = extra['gameId'] as String;

          return BlocProvider(
            create: (_) => FogOfLiesBloc(gameId: gameId)
              ..add(StartFogOfLiesGame(player1: player1, player2: player2)),
            child: FogOfLiesGameScreen(gameId: gameId),
          );
        },
      ),
      GoRoute(
        path: '/fog_of_lies_review',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          final rounds = extras?['rounds'] as List<FogOfLiesRound>?;
          final currentUserId = extras?['currentUserId'] as String?;

          if (rounds == null || currentUserId == null) {
            return const Scaffold(body: Center(child: Text("Missing data")));
          }

          return FogOfLiesReviewScreen(
            rounds: rounds,
            currentUserId: currentUserId,
          );
        },
      ),
      GoRoute(
        path: '/fog_of_lies_leaderboard',
        name: 'fog_of_lies_leaderboard',
        builder: (context, state) => const FogOfLiesLeaderboardScreen(),
      ),
      GoRoute(
        path: '/escape-the-fog/lobby',
        name: 'escapeTheFogLobby',
        builder: (context, state) => const EscapeTheFogLobbyScreen(),
      ),
      GoRoute(
        path: '/escape-the-fog/game',
        name: 'escapeTheFogGame',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: BlocProvider(
              create: (_) => EscapeTheFogBloc(minScoreToEscape: 20),
              child: const EscapeTheFogGameScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/vault',
        builder: (context, state) => const VaultScreen(),
      ),
      GoRoute(
        path: '/trials',
        builder: (context, state) => const TrialSelectorScreen(),
      ),
      GoRoute(
        path: '/trials/memory',
        builder: (context, state) => const MemoryInTheMistScreen(),
      ),
    ],
  );
});
