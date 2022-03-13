import 'dart:io' as IO;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:collection/collection.dart';

import '../../../../config/config.dart';
import '../../../util/json-converter.dart';
import '../base-cloud-repository.dart';

class GoogleDriveRepository extends BaseCloudRepository {
  GoogleDriveRepository() : super();

  @override
  Future<File?> isBackupExist({String? path}) async {
    final driveFileList = await (cloud as DriveApi)
        .files
        .list(spaces: config['cloud']['common']['DRIVE_BACKUP_DIR_PARENT']);
    final isExist = driveFileList.files?.firstWhereOrNull((element) =>
        element.name == config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
    if (isExist == null) {
      return null;
    }
    return isExist;
  }

  @override
  upload(String jsonString, {String? path}) async {
    final filePath = path ?? (await getApplicationDocumentsDirectory()).path;
    final jsonFile = await JsonFile.stringToJsonFile(jsonString,
        dirPath: filePath,
        fileName: config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
    final fileToUpload = File();
    fileToUpload.name = config['cloud']['common']['DRIVE_BACKUP_FILE_NAME'];
    final existFile = await isBackupExist();
    File response;
    try {
      if (existFile != null) {
        response = await (cloud as DriveApi).files.update(
            fileToUpload, existFile.id!,
            uploadMedia: Media(jsonFile.openRead(), jsonFile.lengthSync()));
      } else {
        fileToUpload.parents = [
          config['cloud']['common']['DRIVE_BACKUP_DIR_PARENT']
        ];
        response = await (cloud as DriveApi).files.create(fileToUpload,
            uploadMedia: Media(jsonFile.openRead(), jsonFile.lengthSync()));
      }
      if (kDebugMode) {
        print('cloud : uploaded');
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
        throw Exception('failed to upload to google drive');
      }
    }
  }

  @override
  Future<String?> download({String? path}) async {
    final existFile = await isBackupExist();
    if (existFile == null) {
      return null;
    }
    final Media driveFile = await cloud.files.get(existFile.id!,
        downloadOptions: DownloadOptions.fullMedia) as Media;
    final jsonFileString = await JsonFile.streamToJson(driveFile.stream,
        fileName: config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
    if (kDebugMode) {
      print('cloud json : $jsonFileString');
    }
    return jsonFileString;
  }
}
