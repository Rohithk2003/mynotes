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

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
      ),
      body: Center(
        child: Row(
          children: [
            TextButton(
                onPressed: () async {},
                child: const Center(
                  child: Text("Register"),
                )),
            TextButton(
                onPressed: () async {},
                child: const Center(
                  child: Text("Login"),
                ))
          ],
        ),
      ),
    );
  }
}
