import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/views/login_view.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
  }

  void goToLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  bool clickedVerifyEmail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Please verify your email address"),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: sendEmail,
              style: clickedVerifyEmail
                  ? null
                  : TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
              child: clickedVerifyEmail
                  ? TextButton(
                      onPressed: goToLogin,
                      child: Text("Done?"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                    )
                  : const Text(
                      "Send email verification",
                      style: TextStyle(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
