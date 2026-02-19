import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/models/user_model.dart';
import 'package:tutam_fit/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});

final authStateProvider = StateNotifierProvider<AuthStateNotifier, UserModel?>((
  ref,
) {
  final repo = ref.read(authRepositoryProvider);
  return AuthStateNotifier(repo);
});

class AuthStateNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _repo;

  AuthStateNotifier(this._repo) : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    bool loggedIn = await _repo.isLoggedIn();
    if (loggedIn) {
      state = await _repo.getCurrentUser();
    }
  }

  Future<void> updateProfile({
    required String phone,
    required String city,
    required String role,
  }) async {
    if (state?.id == null) return;

    final updatedUser = await _repo.updateUserProfile(
      id: state!.id!,
      phone: phone,
      city: city,
      role: role,
    );

    state = updatedUser;
  }

  Future<bool> isUserLoggedIn() async {
    return await _repo.isLoggedIn();
  }

  Future<UserModel?> currentUser() async {
    return await _repo.getCurrentUser();
  }

  Future<void> loginEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = await _repo.loginWithEmail(email, password);

    if (state != null) {
      if (state!.role == 'admin') {
        context.go('/admin');
      }
    }
  }

  Future<void> registerEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String role,
  }) async {
    state = await _repo.registerWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
      city: city,
      role: role,
    );
  }

  Future<void> loginGoogle(BuildContext context) async {
    state = await _repo.loginWithGoogle();

    if (state != null) {
      if (state!.role == 'admin') {
        context.go('/admin');
      }
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = null;
  }
}
