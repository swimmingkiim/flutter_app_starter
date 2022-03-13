import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'apple-auth.dart';
import 'base-auth.dart';
import 'google-auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final BaseAuth platformAuth = Platform.isIOS ? AppleAuth() : GoogleAuth();
  User? currentUser;

  Auth() {
    currentUser = _firebaseAuth.currentUser;
  }

  registerUserListener() {
    _firebaseAuth.authStateChanges().listen((user) {
      currentUser = user;
    });
  }

  Future<bool> signIn({OAuthCredential? credential}) async {
    if (currentUser != null) {
      return true;
    }
    final _credential = credential ?? (await platformAuth.getCredential());
    if (_credential == null) {
      return false;
    }
    await _firebaseAuth.signInWithCredential(_credential);
    currentUser = _firebaseAuth.currentUser;
    return true;
  }

  logout() async {
    if (Platform.isAndroid) {
      await (platformAuth as GoogleAuth).logout();
    }
    await _firebaseAuth.signOut();
  }
}
