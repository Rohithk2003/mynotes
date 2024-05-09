import 'dart:developer';

import 'package:MyNotes/constants/routes.dart';
import 'package:MyNotes/services/auth/auth_service.dart';
import 'package:MyNotes/services/crud/notes_service.dart';
import 'package:MyNotes/utilities/showCustomError.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    String text = _textController.text;
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.userEmail;
    final owner = await _notesService.getUser(email: email);
    _note = await _notesService.createNote(owner: owner, text: text);
    if (_note != null) {
      showCustomDialog(
          context,
          "Your note has been saved",
          "Note Saved",
          'Close',
          () => {
                Navigator.pop(context),
              });
    }
    log(_note.toString());
    return _note!;
  }

  // void _saveNoteIfTextNotEmpty() async {
  //   String text = _textController.text;
  //   final existingNote = _note;
  //   log("test");

  //   if (text != "" && existingNote != null) {
  //     showCustomDialog(
  //         context,
  //         "Your note has been saved",
  //         "Note Saved",
  //         'Close',
  //         () => {
  //               Navigator.pop(context),
  //             });
  //     _notesService.updateNote(id: existingNote.id, text: text);
  //   }
  // }

  // void _deleteNoteIfTextIsEmpty() {
  //   String text = _textController.text;
  //   final existingNote = _note;
  //   if (text == "" && existingNote != null) {
  //     _notesService.deleteNote(id: existingNote.id);
  //   }
  // }

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // _deleteNoteIfTextIsEmpty();
    // _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Note"),
          backgroundColor: secondaryColor,
          foregroundColor: textColor,
        ),
        backgroundColor: bgColor,
        body: Center(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 100,
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(
                        backgroundColor: bgColor, color: textColor),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: "Start typing your note here...",
                        hintStyle: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            backgroundColor: bgColor,
                            color: textColor,
                            letterSpacing: .5,
                          ),
                        ),
                        fillColor: textColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: textColor,
                            width: 2.0,
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    createNewNote();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: secondaryColor,
                  ),
                  child: const Text("Save Note",
                      style: TextStyle(
                        color: textColor,
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
