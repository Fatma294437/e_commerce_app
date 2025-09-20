//auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  bool get isLoggedIn => user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      this.user = user;

      notifyListeners();
    });
  }

  Future login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveDeviceToken();
    } catch (e) {
      rethrow;
    }
  }

  Future register(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "uid": cred.user!.uid,
          "email": cred.user!.email,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      await _saveDeviceToken();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveDeviceToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && kIsWeb) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': token,
        });
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final userCred = await _auth.signInWithPopup(provider);

        if (userCred.user != null) {
          final userDoc = await _firestore
              .collection("users")
              .doc(userCred.user!.uid)
              .get();
          if (!userDoc.exists) {
            await _firestore.collection("users").doc(userCred.user!.uid).set({
              "uid": userCred.user!.uid,
              "email": userCred.user!.email,
              "name": userCred.user!.displayName,
              "photoUrl": userCred.user!.photoURL,
              "createdAt": FieldValue.serverTimestamp(),
            });
          }
        }
        await _saveDeviceToken();

        return userCred;
      } else {
        throw UnimplementedError("Google Sign-In متاح حالياً للويب فقط.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
