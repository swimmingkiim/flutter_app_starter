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

  initGoogleDriveCloud(Client newClient) {
    client = newClient;
    cloud = DriveApi(client!);
    if (kDebugMode) {
      print('cloud : set');
    }
  }

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
    // 1. make your json data to json file
    final jsonFile = await JsonFile.stringToJsonFile(jsonString,
        dirPath: filePath,
        fileName: config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
    // 2. instanciate File(this is not from io, but from googleapis
    final fileToUpload = File();
    // 3. set file name for file to upload
    fileToUpload.name = config['cloud']['common']['DRIVE_BACKUP_FILE_NAME'];
    // 4. check if the backup file is already exist
    final existFile = await isBackupExist();
    try {
      // 5. if exist, call update
      if (existFile != null) {
        await (cloud as DriveApi).files.update(fileToUpload, existFile.id!,
            uploadMedia: Media(jsonFile.openRead(), jsonFile.lengthSync()));
      } else {
        // 6. if is not exist, set path for file and call create
        fileToUpload.parents = [
          config['cloud']['common']['DRIVE_BACKUP_DIR_PARENT']
        ];
        await (cloud as DriveApi).files.create(fileToUpload,
            uploadMedia: Media(jsonFile.openRead(), jsonFile.lengthSync()));
      }
      if (kDebugMode) {
        print('cloud : uploaded');
      }
    } catch (err) {
      // 7. catch any error while uploading process
      if (kDebugMode) {
        print(err);
        throw Exception('failed to upload to google drive');
      }
    }
  }

  @override
  Future<String?> download({String? path}) async {
    // 1. check backup before download
    final existFile = await isBackupExist();
    if (existFile == null) {
      return null;
    }
    // 2. get drive file
    final Media driveFile = await cloud.files.get(existFile.id!,
        downloadOptions: DownloadOptions.fullMedia) as Media;
    // 3. read stream from Google Drive to json string
    // In there, I used JsonFile(I didn't mentioned in there)
    // You can use any json package you want to use
    final jsonFileString = await JsonFile.streamToJson(driveFile.stream,
        fileName: config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
    return jsonFileString;
  }
}
