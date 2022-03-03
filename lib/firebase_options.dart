// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC6l2WgmvIPyvHzUQpuTkOGsI3w-pNLkb0',
    appId: '1:1009218136461:web:ca805eed4681f37e4e35c4',
    messagingSenderId: '1009218136461',
    projectId: 'instagram-7eba3',
    authDomain: 'instagram-7eba3.firebaseapp.com',
    storageBucket: 'instagram-7eba3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBy7OItf-2wgZPYoamuswfhVNbzEG56L9M',
    appId: '1:1009218136461:android:74d841407796f7ed4e35c4',
    messagingSenderId: '1009218136461',
    projectId: 'instagram-7eba3',
    storageBucket: 'instagram-7eba3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDW8_wxwwf5bCGkCk4IyXh1046BakeAbmk',
    appId: '1:1009218136461:ios:9eab6e4d2ae41ec34e35c4',
    messagingSenderId: '1009218136461',
    projectId: 'instagram-7eba3',
    storageBucket: 'instagram-7eba3.appspot.com',
    iosClientId: '1009218136461-0u637m1on7483qc4on7jv0qaur2mbd0b.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagram',
  );
}