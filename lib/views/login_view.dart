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
  bool loginBackgroundCheckStarted = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  void handleLoginSuccess() {
    if (mounted) {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/emailverify/', (route) => false);
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/mainpage/', (route) => false);
    }
  }

  void showCustomDialog(String contentText, String titleText, String buttonText,
      Function handleFunction) {
    setState(() {
      loginBackgroundCheckStarted = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(contentText),
            actions: [
              TextButton(
                  onPressed: () {
                    handleFunction();
                  },
                  child: Text(buttonText))
            ],
          );
        });
  }

  Future<void> _login() async {
    setState(() {
      loginBackgroundCheckStarted = true;
    });
    final email = _email.text;
    final password = _password.text;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (mounted) {
        showCustomDialog(
            "Logged in successfully", "Success", "Okay", handleLoginSuccess);
      }
    } on FirebaseException catch (e) {
      if (e.code == "invalid-email") {
        showCustomDialog("Invalid email format.Please try again", "Error",
            "Close", () => {Navigator.pop(context)});
      } else {
        showCustomDialog("Invalid email or password.", "Error", "Close",
            () => {Navigator.pop(context)});
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
                  loginBackgroundCheckStarted
                      ? const CircularProgressIndicator()
                      : SizedBox(
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
