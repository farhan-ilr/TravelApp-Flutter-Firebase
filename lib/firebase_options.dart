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
    apiKey: 'AIzaSyBoeSQ3VtFkPA7obo9FxVWUxkdyL6Nwjds',
    appId: '1:134429990142:web:6123a8cb6ac5d75c2e59af',
    messagingSenderId: '134429990142',
    projectId: 'travel-app-afad4',
    authDomain: 'travel-app-afad4.firebaseapp.com',
    storageBucket: 'travel-app-afad4.appspot.com',
    measurementId: 'G-4J1QP8GEQP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPqiOQrrXfDjFLYa8l9s_cmm_mcppAmf4',
    appId: '1:134429990142:android:67e7ad7516df883f2e59af',
    messagingSenderId: '134429990142',
    projectId: 'travel-app-afad4',
    storageBucket: 'travel-app-afad4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASD5dtxKXkdQl4MQQMrKnVgmno2Vh0Vmc',
    appId: '1:134429990142:ios:ff22f302f71af0aa2e59af',
    messagingSenderId: '134429990142',
    projectId: 'travel-app-afad4',
    storageBucket: 'travel-app-afad4.appspot.com',
    iosClientId: '134429990142-p3s67s1mslvh850k0s83k7nc41u05lu8.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASD5dtxKXkdQl4MQQMrKnVgmno2Vh0Vmc',
    appId: '1:134429990142:ios:ff22f302f71af0aa2e59af',
    messagingSenderId: '134429990142',
    projectId: 'travel-app-afad4',
    storageBucket: 'travel-app-afad4.appspot.com',
    iosClientId: '134429990142-p3s67s1mslvh850k0s83k7nc41u05lu8.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelApp',
  );
}
