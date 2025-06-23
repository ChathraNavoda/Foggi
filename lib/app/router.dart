import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foggi/presentation/screens/auth/register_screen.dart';
import 'package:foggi/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

import '../logic/blocs/auth/auth_state.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authBlocProvider.select((bloc) => bloc.state));

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState is AuthAuthenticated;

      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // If not logged in and trying to go to home
      if (!isLoggedIn && state.matchedLocation == '/home') return '/login';

      // If logged in and trying to go to login/register
      if (isLoggedIn && loggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AnimatedSplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
});
