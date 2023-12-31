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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyAI4r0oVjLX0-H8KSwomxvIIGpjHTw_QiE',
    appId: '1:1009840266224:web:1dbf6e951066d30d365b35',
    messagingSenderId: '1009840266224',
    projectId: 'gallery-social-media',
    authDomain: 'gallery-social-media.firebaseapp.com',
    databaseURL: 'https://gallery-social-media-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gallery-social-media.appspot.com',
    measurementId: 'G-RSXNMK7W3Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDICpS50N5-ntlAC7J8VzreyIa-DRLC3uo',
    appId: '1:1009840266224:android:93efac2e29bc6026365b35',
    messagingSenderId: '1009840266224',
    projectId: 'gallery-social-media',
    databaseURL: 'https://gallery-social-media-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gallery-social-media.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbpOxDMz2wR2Kxgn2frunUspPVYOY2aNw',
    appId: '1:1009840266224:ios:d943370b1189f2f1365b35',
    messagingSenderId: '1009840266224',
    projectId: 'gallery-social-media',
    databaseURL: 'https://gallery-social-media-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gallery-social-media.appspot.com',
    iosClientId: '1009840266224-u2aj6e9cqkk8pmsp68eihag5cj23okt7.apps.googleusercontent.com',
    iosBundleId: 'com.example.galleryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbpOxDMz2wR2Kxgn2frunUspPVYOY2aNw',
    appId: '1:1009840266224:ios:38e4649b989255fe365b35',
    messagingSenderId: '1009840266224',
    projectId: 'gallery-social-media',
    databaseURL: 'https://gallery-social-media-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'gallery-social-media.appspot.com',
    iosClientId: '1009840266224-hjmlq8v8mte0ghugmlvauegq3pdilend.apps.googleusercontent.com',
    iosBundleId: 'com.example.galleryApp.RunnerTests',
  );
}
