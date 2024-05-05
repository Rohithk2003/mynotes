import 'package:flutter/material.dart';
import 'views/LoginView.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
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
