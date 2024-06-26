import 'package:MyNotes/services/auth/auth_providers.dart';
import 'package:MyNotes/services/auth/auth_user.dart';
import 'package:MyNotes/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initializeApp() => provider.initializeApp();

  @override
  Future<void> deleteAccount() => provider.deleteAccount();
}
