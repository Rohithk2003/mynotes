import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String userId;
  final String userEmail;

  const AuthUser({
    required this.isEmailVerified,
    required this.userId,
    required this.userEmail,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        userId: user.email?.split("@")[0] ?? "null",
        userEmail: user.email ?? "null",
      );
}
