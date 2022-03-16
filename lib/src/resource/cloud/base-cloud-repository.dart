import 'package:http/http.dart';

class BaseCloudRepository {
  Client? client;
  dynamic cloud;

  BaseCloudRepository();

  clearData() {
    client = null;
    cloud = null;
  }

  isBackupExist({String? path}) {}

  upload(String jsonString, {String? path}) {}

  download({String? path}) {}
}
