import 'package:MyNotes/constants/routes.dart';
import 'package:MyNotes/services/auth/auth_exceptions.dart';
import 'package:MyNotes/services/auth/auth_service.dart';
import 'package:MyNotes/utilities/showCustomError.dart';
import 'package:flutter/material.dart';
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
      final user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(emailVerifyRoute, (route) => false);
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(notesRoute, (route) => false);
    }
  }

  Future<void> _login() async {
    setState(() {
      loginBackgroundCheckStarted = true;
    });
    final email = _email.text;
    final password = _password.text;
    if (email == "" || password == "") {
      showCustomDialog(
          context, "Please fill the details", "Invalid email", "Okay", () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(emailVerifyRoute, (route) => false);
      });
    } else {
      try {
        await AuthService.firebase().login(
          email: email,
          password: password,
        );
        if (mounted) {
          final user = AuthService.firebase().currentUser;
          setState(() {
            loginBackgroundCheckStarted = false;
          });
          if (!(user?.isEmailVerified ?? false)) {
            showCustomDialog(
                context, "Please verify your email", "Invalid email", "Okay",
                () {
              Navigator.pop(context);
            });
          } else {
            showCustomDialog(context, "Logged in successfully", "Success",
                "Okay", handleLoginSuccess);
          }
        }
      } on InvalidEmailAuthException {
        if (mounted) {
          showCustomDialog(context, "Invalid email format.Please try again",
              "Error", "Close", () => {Navigator.pop(context)});
        }
      } on WrongPasswordAuthException {
        if (mounted) {
          showCustomDialog(context, "Invalid email or password.", "Error",
              "Close", () => {Navigator.pop(context)});
        }
      } on UserNotFoundAuthException {
        if (mounted) {
          showCustomDialog(context, "Invalid email or password.", "Error",
              "Close", () => {Navigator.pop(context)});
        }
      } on GenericAuthException {
        if (mounted) {
          showCustomDialog(context, "Something happened", "Error occured",
              "Close", () => {Navigator.pop(context)});
        }
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
          backgroundColor: secondaryColor,
          foregroundColor: textColor,
        ),
        backgroundColor: bgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Camera',
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    color: textColor,
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
                      style: const TextStyle(fontSize: 16.0, color: textColor),
                      controller: _email,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: const TextStyle(color: textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: secondaryColor,
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
                            color: textColor, letterSpacing: .5),
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                color: textColor, letterSpacing: .5),
                          ),
                          fillColor: textColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: secondaryColor,
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
                                backgroundColor: secondaryColor,
                                foregroundColor: textColor),
                            child: Text(
                              "Login",
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                    color: textColor,
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
                            registerRoute, (route) => false);
                      },
                      child: Text(
                        "Not registered yet ? Register here!",
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              color: textColor, letterSpacing: .5),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}
