import 'package:MyNotes/constants/routes.dart';
import 'package:MyNotes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
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
        future: AuthService.firebase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user == null) {
                return const LoginView();
              } else {
                if (user.isEmailVerified) {
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
