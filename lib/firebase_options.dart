// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCJX9MzegpFnI5ctT9eD0ZpHeC_Ccrhvwg',
    appId: '1:382688706574:web:e007ea748aa96fec1d3c5f',
    messagingSenderId: '382688706574',
    projectId: 'mytodoweb-7f17f',
    authDomain: 'mytodoweb-7f17f.firebaseapp.com',
    storageBucket: 'mytodoweb-7f17f.appspot.com',
    measurementId: 'G-C90WLT70L2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDd6LZlR_shZiKGrhZJax7Y5ZQJqLhwCzk',
    appId: '1:382688706574:android:fb9b7a863d5e73b71d3c5f',
    messagingSenderId: '382688706574',
    projectId: 'mytodoweb-7f17f',
    storageBucket: 'mytodoweb-7f17f.appspot.com',
  );
}