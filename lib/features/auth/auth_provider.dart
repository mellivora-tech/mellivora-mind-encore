import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = ref.read(authServiceProvider);
  return authService.isLoggedIn();
});

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.read(authServiceProvider));
});

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? userName;
  final String? error;

  const AuthState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.userName,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? userName,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      error: error,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AuthState()) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    state = state.copyWith(isLoading: true);
    final loggedIn = await _authService.isLoggedIn();
    final name = loggedIn ? await _authService.getUserName() : null;
    state = state.copyWith(
      isLoggedIn: loggedIn,
      isLoading: false,
      userName: name,
    );
  }

  Future<void> signInWithApple() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _authService.signInWithApple();
    if (result.success) {
      state = state.copyWith(
        isLoggedIn: true,
        isLoading: false,
        userName: result.userName,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _authService.signInWithGoogle();
    if (result.success) {
      state = state.copyWith(
        isLoggedIn: true,
        isLoading: false,
        userName: result.userName,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.error,
      );
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthState();
  }
}
