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
    apiKey: 'mock_api_key_web',
    appId: 'mock_app_id_web',
    messagingSenderId: 'mock_sender_id',
    projectId: 'mock_project_id',
    authDomain: 'mock_project_id.firebaseapp.com',
    storageBucket: 'mock_project_id.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'mock_api_key_android',
    appId: 'mock_app_id_android',
    messagingSenderId: 'mock_sender_id',
    projectId: 'mock_project_id',
    storageBucket: 'mock_project_id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'mock_api_key_ios',
    appId: 'mock_app_id_ios',
    messagingSenderId: 'mock_sender_id',
    projectId: 'mock_project_id',
    storageBucket: 'mock_project_id.appspot.com',
    iosBundleId: 'com.example.baijus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'mock_api_key_macos',
    appId: 'mock_app_id_macos',
    messagingSenderId: 'mock_sender_id',
    projectId: 'mock_project_id',
    storageBucket: 'mock_project_id.appspot.com',
    iosBundleId: 'com.example.baijus',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'mock_api_key_windows',
    appId: 'mock_app_id_windows',
    messagingSenderId: 'mock_sender_id',
    projectId: 'mock_project_id',
    authDomain: 'mock_project_id.firebaseapp.com',
    storageBucket: 'mock_project_id.appspot.com',
  );
}
