import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<OAuthCredential?> getCredential();
  Future<String?> getUid();
  Future<void> setUid(String? uid);
  logout();
}