import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class JsonData {
  JsonData();

  static dynamic convertValue(dynamic value) {
    if (value is String) {
      return value.startsWith('"') ? value : '"$value"';
    } else if (value is List) {
      return toJsonArray(value);
    } else if (value is Map) {
      return toJson(value);
    } else if (value is bool) {
      return value.toString();
    }
    return value;
  }

  static toJson(Map<dynamic, dynamic> data) {
    return data
        .map((key, value) => MapEntry(convertValue(key), convertValue(value)));
  }

  static String toJsonString(Map<String, Object?> data) {
    return data
        .map((key, value) => MapEntry('"$key"', convertValue(value)))
        .toString();
  }

  static toJsonArray(List<dynamic> dataList) {
    return dataList.map((data) => convertValue(data)).toList();
  }

  static String toJsonArrayString(List<dynamic> dataList) {
    return dataList.map((data) => convertValue(data)).toList().toString();
  }

  static Map<String, dynamic> fromJson(String source) {
    var result = jsonDecode(source) as Map<String, dynamic>;
    for (var key in result.keys) {
      if (result[key] is String) {
        if (result[key].toString().startsWith('[') &&
            result[key].toString().endsWith(']')) {
          result[key] = JsonData.fromJsonArray(result[key].toString());
        } else if (result[key].toString().startsWith('{') &&
            result[key].toString().endsWith('}')) {
          result[key] = JsonData.fromJson(result[key]);
        }
      }
    }
    return Map<String, dynamic>.from(result);
  }

  static List<Map<String, dynamic>> fromJsonArray(String source) {
    var result = jsonDecode(source) as List<dynamic>;
    for (var i = 0; i < result.length; i++) {
      if (result[i] is String) {
        if (result[i].toString().startsWith('[') &&
            result[i].toString().endsWith(']')) {
          result[i] = JsonData.fromJsonArray(result[i].toString());
        } else if (result[i].toString().startsWith('{') &&
            result[i].toString().endsWith('}')) {
          result[i] = JsonData.fromJson(result[i].toString());
        }
      }
    }
    return List<Map<String, dynamic>>.from(result);
  }
}

class JsonFile {
  static getFullPath(String dirPath, String fileName) {
    return '$dirPath/$fileName.json';
  }

  static Future<String?> readFileAsJson(
      {String? dirPath, String? fileName}) async {
    if (dirPath == null || fileName == null) {
      return null;
    }
    final path = getFullPath(dirPath, fileName);
    final file = File(path);
    return await file.readAsString();
  }

  static Future<String> streamToJson(Stream stream,
      {String? dirPath, String? fileName}) async {
    List<int> dataList = [];
    final subscription = stream.listen(
        (data) {
          dataList.insertAll(dataList.length, data);
        },
        onDone: () {},
        onError: (error) {
          if (kDebugMode) {
            throw Exception(error.toString());
          }
        });
    final subscriptionAsFuture = subscription.asFuture();
    await Future.wait([subscriptionAsFuture]);
    return await (File(
            '${dirPath ?? (await getTemporaryDirectory()).path}/${fileName ?? 'temp-${DateTime.now().millisecondsSinceEpoch}'}.json')
          ..writeAsBytes(dataList))
        .readAsString();
  }

  static Future<File> stringToJsonFile(String data,
      {String? dirPath, String? fileName}) async {
    final dir = await getTemporaryDirectory();
    final path = getFullPath(dirPath ?? dir.path,
        fileName ?? 'temp-${DateTime.now().millisecondsSinceEpoch}');
    final file = File(path);
    await file.writeAsString(data);
    return file;
  }
}
