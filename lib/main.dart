import 'package:MyNotes/constants/routes.dart';
import 'package:MyNotes/services/auth/auth_service.dart';
import 'package:MyNotes/views/notes/new_note_view.dart';
import 'package:flutter/material.dart';
import 'package:MyNotes/views/email_verification.dart';
import 'package:MyNotes/views/notes/notes_view.dart';
import 'package:MyNotes/views/register_view.dart';
import 'views/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(useMaterial3: true),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      emailVerifyRoute: (context) => const EmailVerification(),
      notesRoute: (context) => const NotesPageView(),
      newNotesRoute: (context) => const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user == null) {
                return const LoginView();
              } else {
                if (user.isEmailVerified) {
                  return const NotesPageView();
                } else {
                  return const EmailVerification();
                }
              }
            default:
              return const Text("Restart the app");
          }
        });
  }
}
