import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String? userName;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.userName,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? userName,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isLoading: isLoading ?? this.isLoading,
    error: error,
    userName: userName ?? this.userName,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@lab.com' && password == 'admin123') {
      state = state.copyWith(isAuthenticated: true, isLoading: false, userName: 'Admin');
    } else {
      state = state.copyWith(isLoading: false, error: 'Email ou mot de passe incorrect');
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
final isAuthenticatedProvider = Provider<bool>((ref) => ref.watch(authProvider).isAuthenticated);
