import 'dart:async';

import 'package:flutter/foundation.dart';

import '../logic/blocs/auth/auth_bloc.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshNotifier(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) {
      notifyListeners(); // 👈 trigger GoRouter to re-evaluate redirect
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
