import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:icloud_storage/icloud_storage.dart';

import '../../../../config/config.dart';
import '../../../util/json-converter.dart';
import '../base-cloud-repository.dart';

class AppleICloudRepository extends BaseCloudRepository {
  ICloudStorage? _icloud;

  AppleICloudRepository() : super();

  _precheck() async {
    _icloud ??= await ICloudStorage.getInstance(
        config['cloud']['common']['ICLOUD_CONTAINER_ID']);
  }

  @override
  isBackupExist({String? path}) async {
    await _precheck();
    final filePath = await JsonFile.getFullPath(
        path ?? (await getApplicationDocumentsDirectory()).path,
        config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
    return await File(filePath).exists();
  }

  @override
  upload(String jsonString, {String? path}) async {
    // 1. check you have instance
    await _precheck();
    // 2. create StreamSubscription to handle file stream from iCloud
    StreamSubscription<double>? _subscription;
    // 3. for checking is subscription end
    Future<dynamic>? _subscriptionFuture;
    bool _isDone = false;
    final dirPath = path ?? (await getApplicationDocumentsDirectory()).path;
    final jsonFile = await JsonFile.stringToJsonFile(jsonString,
        dirPath: dirPath,
        fileName: config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
    await _icloud!.startUpload(
        filePath: jsonFile.path,
        destinationFileName:
            '${config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']}.json',
        onProgress: (stream) {
          // 4. set _subscription
          _subscription = stream.listen((progress) {
            if (kDebugMode) {
              print('upload progress : $progress');
            }
            // 5. success
          }, onDone: () {
            if (kDebugMode) {
              _isDone = true;
              print('upload done!');
            }
            // 6. on error, cancel the stream
          }, onError: (err) {
            if (kDebugMode) {
              print('upload error : $err');
            }
          }, cancelOnError: true);
          // 7. mark as stream started
          _subscriptionFuture = _subscription!.asFuture();
        });
    // 8. check after 7 seconds, if stream is still not ended, just cancel
    Future.delayed(const Duration(seconds: 7), () {
      if (!_isDone) {
        // 9. this will end stream, so _subscriptionFuture also will be end
        _subscription?.cancel();
      }
    });
    // 10. wait for _subscriptionFuture to end(success or error)
    await Future.wait([_subscriptionFuture!]);
    if (kDebugMode) {
      print('ios cloud : upload start');
    }
    return dirPath;
  }

  @override
  Future<String?> download({String? path}) async {
    // 1. check you have instance
    await _precheck();
    // 2. create StreamSubscription to handle file stream from iCloud
    StreamSubscription<double>? _subscription;
    // 3. for checking is subscription end before accessing a downloaded file
    Future<dynamic>? _subscriptionFuture;
    bool _isDone = false;
    final filePath = (await getApplicationDocumentsDirectory()).path;
    try {
      await _icloud!.startDownload(
          fileName:
              '${config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']}.json',
          destinationFilePath: JsonFile.getFullPath(
              filePath, config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']),
          // 4. set _subscription
          onProgress: (stream) {
            _subscription = stream.listen((progress) {
              if (kDebugMode) {
                print('download progress : $progress');
              }
              // 5. success
            }, onDone: () {
              if (kDebugMode) {
                _isDone = true;
                print('download done!');
              }
              // 6. on error, cancel the stream
            }, onError: (err) {
              if (kDebugMode) {
                print('download error : $err');
              }
            }, cancelOnError: true);
            // 7. mark as stream started
            _subscriptionFuture = _subscription!.asFuture();
          });
      // 8. check after 7 seconds, if stream is still not ended, just cancel
      Future.delayed(const Duration(seconds: 7), () async {
        if (!_isDone) {
          _isDone = true;
          // 9. this will end stream, so _subscriptionFuture also will be end
          _subscription?.cancel();
        }
      });
      // 10. wait for _subscriptionFuture to end(success or error)
      await Future.wait([_subscriptionFuture!]);
      // 11. read downloaded file content
      // In there, I used JsonFile(I didn't mentioned in there)
      // You can use any json package you want to use
      final jsonString = await JsonFile.readFileAsJson(
          dirPath: path ?? filePath,
          fileName: config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
      if (kDebugMode) {
        print('ios cloud : downloaded from icloud dir');
      }
      return jsonString;
    } catch (e) {
      // 12. catch any error occured on using iClould package
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
