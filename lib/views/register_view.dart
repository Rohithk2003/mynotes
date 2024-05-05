import 'package:MyNotes/constants/routes.dart';
import 'package:MyNotes/utilities/showCustomError.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../configs/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String errorText = "";
  bool registerButtonClicked = false;

  void _registerUser() async {
    setState(() {
      registerButtonClicked = true;
    });
    final email = _email.text;
    final password = _password.text;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;
        await user?.sendEmailVerification();
      }
      if (mounted) {
        setState(() {
          registerButtonClicked = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                    const Text("Your account has been successfully created"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed(emailVerifyRouter);
                      },
                      child: const Text("Okay"))
                ],
              );
            });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (mounted) {
          setState(() {
            registerButtonClicked = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text("Email Already Exists"),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"))
                  ],
                );
              });
        }
      } else if (e.code == "weak-password") {
        if (mounted) {
          setState(() {
            registerButtonClicked = false;
          });
          showCustomDialog(context, "Weak Password", "Error", "Close", () {
            Navigator.of(context).pop();
          });
        }
      } else if (e.code == "invalid-email") {
        if (mounted) {
          setState(() {
            registerButtonClicked = false;
          });
          showCustomDialog(context, "Invalid Email", "Error", "Close", () {
            Navigator.of(context).pop();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            registerButtonClicked = false;
          });
          showCustomDialog(
              context,
              "Something happened on our end. Please  try again later",
              "Error",
              "Close", () {
            Navigator.of(context).pop();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          registerButtonClicked = false;
        });
        showCustomDialog(
            context,
            "Something happened on our end. Please  try again later",
            "Error",
            "Close", () {
          Navigator.of(context).pop();
        });
      }
    }
  }

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
          title: const Text("Register Account"),
          backgroundColor: secondaryColor,
          foregroundColor: textColor,
        ),
        backgroundColor: bgColor,
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
                      const Text(
                        "My Notes",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
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
                                style: const TextStyle(
                                    fontSize: 16.0, color: textColor),
                                controller: _email,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: "Enter your email",
                                    hintStyle:
                                        const TextStyle(color: textColor),
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
                              width: 500,
                              child: TextField(
                                controller: _password,
                                obscureText: true,
                                enableSuggestions: false,
                                style: const TextStyle(color: textColor),
                                autocorrect: false,
                                decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    hintStyle:
                                        const TextStyle(color: textColor),
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
                            registerButtonClicked
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: _registerUser,
                                    style: TextButton.styleFrom(
                                        backgroundColor: secondaryColor,
                                        foregroundColor: textColor),
                                    child: const Text("Register"),
                                  ),
                            Text(errorText),
                            TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      loginRouter, (route) => false);
                                },
                                child: const Text(
                                  "Already registered? Login here!",
                                  style: TextStyle(color: textColor),
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
