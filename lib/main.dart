import 'package:MyNotes/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:MyNotes/configs/firebase_options.dart';
import 'package:MyNotes/views/email_verification.dart';
import 'package:MyNotes/views/main_page.dart';
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
      loginRouter: (context) => const LoginView(),
      registerRouter: (context) => const RegisterView(),
      emailVerifyRouter: (context) => const EmailVerification(),
      notesRouter: (context) => const MainPageView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return const LoginView();
              } else {
                if (user.emailVerified) {
                  return const MainPageView();
                } else {
                  return const EmailVerification();
                }
              }
            default:
              return const Text("ERROR");
          }
        });
  }
}
