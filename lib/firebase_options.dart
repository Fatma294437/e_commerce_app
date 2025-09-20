//firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAT_hWzzm6EihhyU2uZdZTaSWcsyj-I5y0",
    authDomain: "ecommerce-app-6a8cc.firebaseapp.com",
    projectId: "ecommerce-app-6a8cc",
    storageBucket: "ecommerce-app-6a8cc.firebasestorage.app",
    messagingSenderId: "486269813863",
    appId: "1:486269813863:web:41cbd85b1549241fe480c2",
    measurementId: "G-2NLJLR5QMG",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAT_hWzzm6EihhyU2uZdZTaSWcsyj-I5y0",
    appId: "1:486269813863:android:41cbd85b1549241fe480c2",
    messagingSenderId: "486269813863",
    projectId: "ecommerce-app-6a8cc",
    storageBucket: "ecommerce-app-6a8cc.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAT_hWzzm6EihhyU2uZdZTaSWcsyj-I5y0",
    appId: "1:486269813863:ios:41cbd85b1549241fe480c2",
    messagingSenderId: "486269813863",
    projectId: "ecommerce-app-6a8cc",
    storageBucket: "ecommerce-app-6a8cc.firebasestorage.app",
    iosBundleId: "com.example.ecommerceapp",
  );
}
