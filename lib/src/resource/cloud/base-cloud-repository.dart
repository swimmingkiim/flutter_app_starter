import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';

class BaseCloudRepository {
  Client? client;
  dynamic cloud;

  BaseCloudRepository();

  initGoogleDriveCloud(Client newClient) {
    client = newClient;
    cloud = DriveApi(client!);
    if (kDebugMode) {
      print('cloud : set');
    }
  }

  clearData() {
    client = null;
    cloud = null;
  }

  isBackupExist({String? path}) {}

  upload(String jsonString, {String? path}) {}

  download({String? path}) {}
}
