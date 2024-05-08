import 'package:MyNotes/constants/routes.dart';
import 'package:MyNotes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  Future<void> sendEmail() async {
    setState(() {
      clickedVerifyEmail = true;
    });
    AuthService.firebase().sendEmailVerification();
  }

  void goToLogin() async {
    AuthService.firebase().logout();
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(loginRoute, (route) => false);
    }
  }

  bool clickedVerifyEmail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
        backgroundColor: secondaryColor,
      ),
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "We have sent you an email verification. Please open it to verify your account. After Verifying please login in.",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    color: textColor,
                    letterSpacing: .5,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "If you haven't recieved a verification email yet, press the button below",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    color: textColor,
                    letterSpacing: .5,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: sendEmail,
              style: clickedVerifyEmail
                  ? null
                  : TextButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: textColor,
                    ),
              child: const Text("Send email verification again."),
            ),
            TextButton(
              onPressed: goToLogin,
              style: TextButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: textColor,
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
