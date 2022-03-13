import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../config/config.dart';
import 'base-auth.dart';

class AppleAuth extends BaseAuth {
  @override
  Future<OAuthCredential?> getCredential() async {
    try {
      await SignInWithApple.isAvailable();
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);
      final OAuthCredential oauthCredential = OAuthProvider('apple.com')
          .credential(
              idToken: credential.identityToken,
              accessToken: credential.authorizationCode);
      return oauthCredential;
    } catch (e) {
      if (kDebugMode) {
        switch (e) {
          case SignInWithAppleNotSupportedException:
            print('error : sign in with apple not available');
            break;
          case SignInWithAppleException:
            print('error : sign in failed');
        }
      }
      return null;
    }
  }

  @override
  Future<void> setUid(String? uid) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: config['auth']['apple']['UID'], value: uid);
  }

  @override
  Future<String?> getUid() async {
    final secureStorage = FlutterSecureStorage();
    final uid = await secureStorage.read(key: config['auth']['apple']['UID']);
    if (uid == null) {
      return null;
    }
    return uid;
  }

  @override
  logout() {
    setUid(null);
  }
}
