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

import '../data/models/riddle.dart';
import '../data/models/riddle_results.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_state.dart';
import '../logic/blocs/riddle/riddle_game_bloc.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/leaderboard/leaderboard_screen.dart';
import '../presentation/screens/riddle/riddle_review_screen.dart';
import '../presentation/screens/riddle/riddle_screen.dart';
import '../presentation/screens/splash_screen.dart';
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
    ],
  );
});
