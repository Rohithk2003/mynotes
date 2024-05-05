import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:developer' as devtools show log;

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

enum MenuAction { logout }

class _MainPageViewState extends State<MainPageView> {
  String user =
      FirebaseAuth.instance.currentUser?.email.toString().split("@")[0] ?? "";

  Future<void> showLogOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign out'),
            content: const Text("Are you sure you want to sign out"),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    logout();
                  },
                  child: const Text("Sign out")),
            ],
          );
        });
  }

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
          title: Text(user),
          backgroundColor: const Color.fromRGBO(28, 27, 21, 1),
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton<MenuAction>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.all(0),
                offset: const Offset(0, 56),
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      await showLogOutDialog(context);
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem<MenuAction>(
                        padding: const EdgeInsets.all(0),
                        value: MenuAction.logout,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromRGBO(41, 41, 27, 1),
                              width: 1,
                            ),
                            color: const Color.fromRGBO(41, 41, 27, 1),
                          ),
                          width: 300,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: ListTile(
                                style: ListTileStyle.list,
                                leading: Icon(Icons.logout),
                                title: Text(
                                  "Logout",
                                  style: TextStyle(
                                    backgroundColor:
                                        Color.fromRGBO(41, 41, 27, 1),
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      )
                    ]),
          ],
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
