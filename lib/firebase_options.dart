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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAqFACKdmOmfRUZyPjCtUE0rkVzdRQle20',
    appId: '1:584267922329:web:6f5b3eaa4da5b13cf6b108',
    messagingSenderId: '584267922329',
    projectId: 'hand-cric',
    authDomain: 'hand-cric.firebaseapp.com',
    databaseURL:
        'https://hand-cric-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hand-cric.appspot.com',
    measurementId: 'G-BGT7C72F5H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTgZShaFJxLZejO3OH02NVT3uKk9H6txA',
    appId: '1:584267922329:android:d31a6769b825ffeaf6b108',
    messagingSenderId: '584267922329',
    projectId: 'hand-cric',
    databaseURL:
        'https://hand-cric-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hand-cric.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvP7tdoz5wZ8xDnRJYuYi_qXV9auNdpTA',
    appId: '1:584267922329:ios:70d0278e152134fdf6b108',
    messagingSenderId: '584267922329',
    projectId: 'hand-cric',
    databaseURL:
        'https://hand-cric-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hand-cric.appspot.com',
    iosBundleId: 'com.example.handCric',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAqFACKdmOmfRUZyPjCtUE0rkVzdRQle20',
    appId: '1:584267922329:web:70a2a53dad31337af6b108',
    messagingSenderId: '584267922329',
    projectId: 'hand-cric',
    authDomain: 'hand-cric.firebaseapp.com',
    databaseURL:
        'https://hand-cric-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'hand-cric.appspot.com',
    measurementId: 'G-RKDPDBMWY4',
  );
}
