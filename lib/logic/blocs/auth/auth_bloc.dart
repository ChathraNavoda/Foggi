import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// final authBlocProvider = Provider<AuthBloc>((ref) {
//   throw UnimplementedError('AuthBloc is not available yet');
// });

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);

    on<AuthGoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signInWithGoogle();
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError("Google sign-in failed"));
      }
    });
  }

  Future<void> _onCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(event.email, event.password);
      emit(AuthAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    }
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(event.email, event.password);
      emit(AuthAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Registration failed"));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    await Future.delayed(const Duration(milliseconds: 600)); // ⏳ Small delay
    emit(AuthUnauthenticated());
  }
}
