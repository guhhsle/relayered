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
    apiKey: 'AIzaSyDGpEQYTrJoxD7IKwGRYD3Eu_zGbvZvvWI',
    appId: '1:675281183231:web:c52713b2e93a705e1f47ca',
    messagingSenderId: '675281183231',
    projectId: 'relayered-39',
    authDomain: 'relayered-39.firebaseapp.com',
    storageBucket: 'relayered-39.appspot.com',
    measurementId: 'G-E9BWD4GDWF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNMIrMkbdJlyvvzyiN-6aR7KnpOYmk7nU',
    appId: '1:675281183231:android:fced4c0d2e302e321f47ca',
    messagingSenderId: '675281183231',
    projectId: 'relayered-39',
    storageBucket: 'relayered-39.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqZM_keKzIFu6oevKinorGrKi7k8Auz7A',
    appId: '1:675281183231:ios:d72b704471f68f911f47ca',
    messagingSenderId: '675281183231',
    projectId: 'relayered-39',
    storageBucket: 'relayered-39.appspot.com',
    iosBundleId: 'com.guhhsle.relayered',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqZM_keKzIFu6oevKinorGrKi7k8Auz7A',
    appId: '1:675281183231:ios:3a9cd96471923e261f47ca',
    messagingSenderId: '675281183231',
    projectId: 'relayered-39',
    storageBucket: 'relayered-39.appspot.com',
    iosBundleId: 'com.guhhsle.relayered.RunnerTests',
  );
}
