import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

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
      await FirebaseAuth.instance
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
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black87,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Notes',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 500,
                    child: TextField(
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                      controller: _email,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 500,
                    child: TextField(
                      controller: _password,
                      obscureText: true,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                            color: Colors.white, letterSpacing: .5),
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                color: Colors.white, letterSpacing: .5),
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextButton(
                      onPressed: _login,
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      child: Text(
                        "Login",
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Text(errorText),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register/', (route) => false);
                      },
                      child: Text(
                        "Not registered yet ? Register here!",
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              color: Colors.green, letterSpacing: .5),
                        ),
                      )),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/emailverify/', (route) => false);
                      },
                      child: Text(
                        "Verify email !",
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              color: Colors.green, letterSpacing: .5),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ));
  }
}
