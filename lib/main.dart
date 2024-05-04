import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'configs/firebase_options.dart';
import 'views/LoginView.dart';
import 'views/RegisterView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: const LoginView(),
  ));
}
