import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list/repositories/auth_repository.dart';

final authControllerProvider = Provider<AuthController>(
  (ref) => AuthController(ref.read)..appStarted(),
);

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangedSubscription;

  AuthController(this._read) : super(null) {
    _authStateChangedSubscription?.cancel();
    _authStateChangedSubscription =
        _read(authRepositoryProvider).authStateChanges.listen((user) {
      state = user;
    });
  }

  @override
  void dispose() {
    _authStateChangedSubscription?.cancel();
    super.dispose();
  }

  void appStarted() async {
    final user = _read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      await _read(authRepositoryProvider).signInAnonymously();
    }
  }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
