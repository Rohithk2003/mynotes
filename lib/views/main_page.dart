import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _MainPageViewState extends State<MainPageView> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Logged out."),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login/', (route) => false);
                    },
                    child: const Text("Okay"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  onPressed: logout,
                  child: Text(
                    "Logout",
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          color: Colors.black, letterSpacing: .5),
                    ),
                  ))),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black87,
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'My Notes',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      letterSpacing: .5,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ));
  }
}
