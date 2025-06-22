import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foggi/core/theme/theme_provider.dart';

import 'app/router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: FoggiApp()));
}

class FoggiApp extends ConsumerWidget {
  const FoggiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Foggi',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
