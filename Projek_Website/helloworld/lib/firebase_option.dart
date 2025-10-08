// lib/firebase_options.dart
// Generated via FlutterFire CLI

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'FirebaseOptions belum dikonfigurasi untuk Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'FirebaseOptions belum dikonfigurasi untuk Linux.',
        );
      default:
        throw UnsupportedError(
          'Platform tidak didukung.',
        );
    }
  }

  /// ==== WEB ====
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJsdoGEswudXnFnHHYF2LwBhtkTNrAz2U',
    appId: '1:971941173900:web:8999392a62ec52e5a539a9',
    messagingSenderId: '971941173900',
    projectId: 'mentis-learning',
    authDomain: 'mentis-learning.firebaseapp.com',
    storageBucket: 'mentis-learning.firebasestorage.app',
    measurementId: 'G-MSD4RT5H9G',
  );

  /// ==== ANDROID ====
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBE7Sa6B_Gi-GZAz5ZFhYR0Cbp7jvOqRYU',
    appId: '1:971941173900:android:63fcd6b71c9568d0a539a9',
    messagingSenderId: '971941173900',
    projectId: 'mentis-learning',
    storageBucket: 'mentis-learning.firebasestorage.app',
  );
}