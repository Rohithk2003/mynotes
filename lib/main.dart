import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mynotes/configs/firebase_options.dart';
import 'package:mynotes/views/register_view.dart';
import 'views/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'My Notes',
    theme: ThemeData(useMaterial3: true, primarySwatch: Colors.amber),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("My Notes")),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = FirebaseAuth.instance.currentUser;
                  String verificationMessage = user?.emailVerified == true
                      ? "Email Verified"
                      : "Please verify your email";
                  return Center(
                      child: Column(
                    children: [
                      const SizedBox(
                        width: 400,
                        height: 200,
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterView()),
                            );
                          },
                          child: const Text("Register"),
                        ),
                      ),
                      const SizedBox(
                        width: 400,
                        height: 30,
                      ),
                      Text(verificationMessage),
                      const SizedBox(
                        width: 400,
                        height: 20,
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()),
                            );
                          },
                          child: const Text("Login"),
                        ),
                      )
                    ],
                  ));
                default:
                  return const Text("ERROR");
              }
            }));
  }
}
