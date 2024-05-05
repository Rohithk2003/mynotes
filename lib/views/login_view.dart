import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../configs/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String errorText = "";
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  Future<void> _login() async {
    final email = _email.text;
    final password = _password.text;
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        errorText = "You are successfully logged in";
      });
    } on FirebaseException catch (e) {
      if (e.code == "invalid-email") {
        setState(() {
          errorText = "Invalid email.";
        });
      } else {
        setState(() {
          errorText =
              "Invalid username or password.If you dont have an account please create one.";
        });
      }
      Fluttertoast.showToast(
        msg: "Authentication failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
          title: const Text("Login"),
          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.black87,
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                                controller: _email,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: "Enter your email",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _password,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextButton(
                              onPressed: _login,
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white),
                              child: const Text("Login"),
                            ),
                            Text(errorText),
                            TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/register/', (route) => false);
                                },
                                child: const Text(
                                  "Not registered yet ? Register here!",
                                  style: TextStyle(color: Colors.green),
                                )),
                            TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/emailverify/', (route) => false);
                                },
                                child: const Text(
                                  "Verify email !",
                                  style: TextStyle(color: Colors.green),
                                ))
                          ],
                        ),
                      ),
                    ],
                  );
              }
            }));
  }
}
