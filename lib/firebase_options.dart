// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvybQJNV-HyLnFW_0IGvkkJwpGz5LSnd4',
    appId: '1:362211455570:web:c1b8ba4896ceae1408258b',
    messagingSenderId: '362211455570',
    projectId: 'new-my-app-1801',
    authDomain: 'new-my-app-1801.firebaseapp.com',
    storageBucket: 'new-my-app-1801.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjvX0xqs-_FBWN9hipq6kbF1KvaTVJMco',
    appId: '1:362211455570:android:791a4e058a4220bd08258b',
    messagingSenderId: '362211455570',
    projectId: 'new-my-app-1801',
    storageBucket: 'new-my-app-1801.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApTPPfihNCtGV4J-ckuhTuWxNnHAueKik',
    appId: '1:362211455570:ios:a361055ef68749fe08258b',
    messagingSenderId: '362211455570',
    projectId: 'new-my-app-1801',
    storageBucket: 'new-my-app-1801.appspot.com',
    iosBundleId: 'com.example.mynotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyApTPPfihNCtGV4J-ckuhTuWxNnHAueKik',
    appId: '1:362211455570:ios:a361055ef68749fe08258b',
    messagingSenderId: '362211455570',
    projectId: 'new-my-app-1801',
    storageBucket: 'new-my-app-1801.appspot.com',
    iosBundleId: 'com.example.mynotes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCvybQJNV-HyLnFW_0IGvkkJwpGz5LSnd4',
    appId: '1:362211455570:web:66f87593fbc6dcf708258b',
    messagingSenderId: '362211455570',
    projectId: 'new-my-app-1801',
    authDomain: 'new-my-app-1801.firebaseapp.com',
    storageBucket: 'new-my-app-1801.appspot.com',
  );
}
