import 'dart:developer';

import 'package:MyNotes/constants/routes.dart';
import 'package:MyNotes/services/auth/auth_service.dart';
import 'package:MyNotes/services/crud/notes_service.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:developer' as devtools show log;

class NotesPageView extends StatefulWidget {
  const NotesPageView({super.key});

  @override
  State<NotesPageView> createState() => _NotesPageViewState();
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum MenuAction { logout, delete }

class _NotesPageViewState extends State<NotesPageView> {
  late final NotesService _notesService;
  String user = AuthService.firebase().currentUser?.userEmail ?? "";

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  Future<void> showLogOutDialog(BuildContext context, String contentText,
      String titleText, Function handleFunction) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(contentText),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    handleFunction();
                  },
                  child: Text(titleText)),
            ],
          );
        });
  }

  void logout() async {
    await AuthService.firebase().logout();
    if (mounted) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Logged out."),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRouter, (route) => false);
                    },
                    child: const Text("Close"))
              ],
            );
          });
    }
  }

  void deleteAccount() async {
    await AuthService.firebase().deleteAccount();
    if (mounted) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
                  const Text("Your account has been successfully deleted."),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRouter, (route) => false);
                    },
                    child: const Text("Close"))
              ],
            );
          });
    }
  }

  final items = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: ListTile(
            style: ListTileStyle.list,
            leading: const Icon(Icons.account_circle),
            title: Text(
              user,
              style: const TextStyle(
                color: textColor,
              ),
            ),
          ),
          backgroundColor: const Color.fromRGBO(28, 27, 21, 1),
          foregroundColor: textColor,
          actions: [
            PopupMenuButton<MenuAction>(
                padding: const EdgeInsets.all(0),
                offset: const Offset(0, 56),
                onSelected: (value) async {
                  log(value.toString());
                  switch (value) {
                    case MenuAction.logout:
                      await showLogOutDialog(
                          context, "Are you sure ?", "Sign Out", logout);
                      break;
                    case MenuAction.delete:
                      await showLogOutDialog(
                          context,
                          "Are you sure that yo u want to delete your account? This action is irreversible.",
                          "Delete Account",
                          deleteAccount);
                      break;
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem<MenuAction>(
                        padding: const EdgeInsets.all(0),
                        value: MenuAction.logout,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(41, 41, 27, 1),
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
                                    color: textColor,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      PopupMenuItem<MenuAction>(
                        padding: const EdgeInsets.all(0),
                        value: MenuAction.delete,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(41, 41, 27, 1),
                          ),
                          width: 300,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: ListTile(
                                style: ListTileStyle.list,
                                leading: Icon(Icons.delete),
                                title: Text(
                                  "Delete account",
                                  style: TextStyle(
                                    backgroundColor:
                                        Color.fromRGBO(41, 41, 27, 1),
                                    color: textColor,
                                  ),
                                )),
                          ),
                        ),
                      )
                    ]),
          ],
        ),
        backgroundColor: bgColor,
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: user),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text(
                          "waiting for all notes...",
                          style: TextStyle(color: textColor),
                        );
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(child: Text(text)),
      ),
    );
  }
}
