import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../../../config/config.dart';
import 'base-auth.dart';

class GoogleAuth extends BaseAuth {
  Map<String, String>? _authHeaders;
  Client? client;
  // TODO : edit scopes as you want
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'https://www.googleapis.com/auth/drive.file',
    DriveApi.driveAppdataScope
  ]);

  GoogleAuth() : super() {
    _initLoginListener();
  }

  @override
  Future<OAuthCredential?> getCredential() async {
    GoogleSignInAccount? _googleAccount;
    if (_googleSignIn.currentUser == null) {
      _googleAccount = await _googleSignIn.signInSilently();
      if (_googleSignIn.currentUser == null) {
        _googleAccount = await _googleSignIn.signIn();
      }
    }
    if (_googleAccount == null) {
      return null;
    }
    final _authentication = await _googleAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: _authentication.idToken,
        accessToken: _authentication.accessToken);
    return credential;
  }

  @override
  Future<void> setUid(String? uid) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: config['auth']['google']['UID'], value: uid);
  }

  @override
  Future<String?> getUid() async {
    final secureStorage = FlutterSecureStorage();
    final uid = await secureStorage.read(key: config['auth']['google']['UID']);
    if (uid == null) {
      return null;
    }
    return uid;
  }

  _initLoginListener() {
    _googleSignIn.onCurrentUserChanged.listen((account) async {
      if (account == null) {
        if (kDebugMode) {
          print('not login');
        }
        _clearData();
      } else {
        if (kDebugMode) {
          print('login : $account');
        }
      }
    });
    _googleSignIn.signInSilently();
  }

  _clearData() {
    _authHeaders = null;
    client = null;
  }

  _setClient() {
    if (_authHeaders != null) {
      client = GoogleApiClient(_authHeaders!);
    }
  }

  _setHeaderWithAccessToken() async {
    _authHeaders = await _googleSignIn.currentUser!.authHeaders;
  }

  Future<OAuthCredential?> login() async {
    final credential = await getCredential();
    await _setHeaderWithAccessToken();
    await _setClient();
    return credential;
  }

  @override
  logout() async {
    await _googleSignIn.signOut();
    await setUid(null);
  }
}

class GoogleApiClient extends IOClient {
  late Map<String, String> _authHeaders;
  GoogleApiClient(this._authHeaders) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) {
    return super.send(request..headers.addAll(_authHeaders));
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    return super.head(url,
        headers: headers ?? {}
          ..addAll(_authHeaders));
  }
}
