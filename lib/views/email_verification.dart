import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    FirebaseAuth.instance.currentUser;
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login/', (route) => false);
    }
  }

  bool clickedVerifyEmail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please verify your email address",
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: sendEmail,
              style: clickedVerifyEmail
                  ? null
                  : TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
              child: clickedVerifyEmail
                  ? TextButton(
                      onPressed: goToLogin,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Done?"),
                    )
                  : const Text(
                      "Send email verification",
                      style: TextStyle(),
                    ),
            ),
            TextButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/register/', (route) => false);
                },
                child: const Text(
                  "Not registered yet ? Register here!",
                  style: TextStyle(color: Colors.green),
                )),
            TextButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
                },
                child: const Text(
                  "Want to login?",
                  style: TextStyle(color: Colors.green),
                ))
          ],
        ),
      ),
    );
  }
}
