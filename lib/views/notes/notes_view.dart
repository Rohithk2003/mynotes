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

enum MenuAction { logout, delete }

Future<void> showCustomDialogs(BuildContext context, String contentText,
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
                          loginRoute, (route) => false);
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
                          registerRoute, (route) => false);
                    },
                    child: const Text("Close"))
              ],
            );
          });
    }
  }

  void redirectToNoteView() {
    Navigator.of(context).pushNamed(newNotesRoute);
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
            SizedBox(
              width: 50,
              child: TextButton(
                  onPressed: redirectToNoteView,
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      color: textColor,
                    ),
                  )),
            ),
            PopupMenuButton<MenuAction>(
                padding: const EdgeInsets.all(0),
                offset: const Offset(0, 56),
                onSelected: (value) async {
                  log(value.toString());
                  switch (value) {
                    case MenuAction.logout:
                      await showCustomDialogs(
                          context, "Are you sure ?", "Sign Out", logout);
                      break;
                    case MenuAction.delete:
                      await showCustomDialogs(
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
        body: Stack(children: [
          Column(
            children: [
              const SizedBox(
                height: 90,
                width: double.infinity,
                child: Center(
                  child: Text("Upload Image",
                      style: TextStyle(fontSize: 40, color: textColor)),
                ),
              ),
              FutureBuilder(
                future: _notesService.getOrCreateUser(email: user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return StreamBuilder(
                        stream: _notesService.allNotes,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                final allNotes =
                                    snapshot.data as List<DatabaseNote>;
                                return SizedBox(
                                  height: 700,
                                  child: ListView.builder(
                                    itemCount: allNotes.length,
                                    itemBuilder: (context, index) {
                                      final note = allNotes[index];
                                      return ItemWidget(
                                        text: note.text,
                                        currentNote: note,
                                        notesService: _notesService,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            default:
                              return const CircularProgressIndicator();
                          }
                        },
                      );
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 65,
              height: 65,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  right: 16.0,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    redirectToNoteView();
                  },
                  backgroundColor: textColor, // Change background color
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
    required this.currentNote,
    required this.notesService,
  });
  final String text;
  final DatabaseNote currentNote;
  final NotesService notesService;
  // TextEditingController newNoteText;
  // final bool editingOptionAvailable = false;

  void deleteNote() async {
    await notesService.deleteNote(id: currentNote.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: TextButton(
              onPressed: () async {
                await showCustomDialogs(context, "Are you sure ?",
                    "Delete Note", () => {deleteNote()});
              },
              child: const Icon(
                Icons.delete,
                color: bgColor,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: TextButton(
              onPressed: () async {},
              child: const Icon(
                Icons.edit,
                color: bgColor,
                size: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
            width: 30,
            child: VerticalDivider(width: 5, thickness: 1, color: Colors.black),
          ),
          SizedBox(
            height: 60,
            child: Center(
                child: Text(
              text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            )),
          ),
        ],
      ),
    );
  }
}

// A screen that allows users to take a picture using a given camera.
