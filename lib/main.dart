import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/configs/firebase_options.dart';
import 'package:mynotes/views/email_verification.dart';
import 'package:mynotes/views/register_view.dart';
import 'views/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(useMaterial3: true, primarySwatch: Colors.green),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/emailverify/': (context) => const EmailVerification()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("My Notes")),
          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.black87,
        body: FutureBuilder(
            future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = FirebaseAuth.instance.currentUser;

                  bool verificationMessage =
                      user?.emailVerified == true ? true : false;
                  if (user == null) verificationMessage = true;
                  if (verificationMessage) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/register/', (route) => false);
                            },
                            child: const Text("Register"),
                          ),
                        ),
                        const SizedBox(
                          width: 400,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 400,
                          height: 20,
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login/', (route) => false);
                            },
                            child: const Text("Login"),
                          ),
                        )
                      ],
                    ));
                  } else {
                    return Center(
                      child: SizedBox(
                        width: 100,
                        height: 300,
                        child: Center(
                          child: TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EmailVerification()));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Verify Email"),
                          ),
                        ),
                      ),
                    );
                  }
                default:
                  return const Text("ERROR");
              }
            }));
  }
}
