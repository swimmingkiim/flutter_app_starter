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
    await _precheck();
    StreamSubscription<double>? _subscription;
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
          _subscription = stream.listen((progress) {
            if (kDebugMode) {
              print('upload progress : $progress');
            }
          }, onDone: () {
            if (kDebugMode) {
              _isDone = true;
              print('upload done!');
            }
          }, onError: (err) {
            if (kDebugMode) {
              print('upload error : $err');
            }
          }, cancelOnError: true);
          _subscriptionFuture = _subscription!.asFuture();
        });
    Future.delayed(const Duration(seconds: 7), () {
      if (!_isDone) {
        _subscription?.cancel();
      }
    });
    await Future.wait([_subscriptionFuture!]);
    if (kDebugMode) {
      print('ios cloud : upload start');
    }
    return dirPath;
  }

  @override
  Future<String?> download({String? path}) async {
    await _precheck();
    StreamSubscription<double>? _subscription;
    Future<dynamic>? _subscriptionFuture;
    bool _isDone = false;
    final filePath = (await getApplicationDocumentsDirectory()).path;
    try {
      await _icloud!.startDownload(
          fileName:
              '${config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']}.json',
          destinationFilePath: JsonFile.getFullPath(
              filePath, config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']),
          onProgress: (stream) {
            _subscription = stream.listen((progress) {
              if (kDebugMode) {
                print('download progress : $progress');
              }
            }, onDone: () {
              if (kDebugMode) {
                _isDone = true;
                print('download done!');
              }
            }, onError: (err) {
              if (kDebugMode) {
                print('download error : $err');
              }
            }, cancelOnError: true);
            _subscriptionFuture = _subscription!.asFuture();
          });
      Future.delayed(const Duration(seconds: 7), () async {
        if (!_isDone) {
          _isDone = true;
          _subscription?.cancel();
        }
      });
      await Future.wait([_subscriptionFuture!]);
      final jsonString = await JsonFile.readFileAsJson(
          dirPath: path ?? filePath,
          fileName: config['cloud']['common']['DRIVE_BACKUP_FILE_NAME']);
      if (kDebugMode) {
        print('ios cloud : downloaded from icloud dir');
      }
      return jsonString;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
