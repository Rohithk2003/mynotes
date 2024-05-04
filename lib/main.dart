import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

String test() {
  return "Hello";
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: InputDecoration(hintText: "Username"),
          ),
          TextField(
            controller: _password,
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: "Password"),
          ),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text("Login")),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    final UserCredential = FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);
                    print(UserCredential);
                  },
                  child: const Text("Register")),
            ],
          ),
        ],
      ),
    );
  }
}
