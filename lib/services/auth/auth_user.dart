import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String userId;
  const AuthUser(this.isEmailVerified, this.userId);

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(user.emailVerified, user.email?.split("@")[0] ?? "null");
}
