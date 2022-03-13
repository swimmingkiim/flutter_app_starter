import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';



class GoogleAuth {

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.file', DriveApi.driveAppdataScope]);



  logout() async {
    await _googleSignIn.signOut();
  }
}