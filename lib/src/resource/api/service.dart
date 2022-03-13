import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/config.dart';
import '../../model/UserAccount.dart';
import '../../util/json-converter.dart';

class APIService {
  late UserService user;
  late PaymentService payment;

  APIService() {
    user = UserService();
    payment = PaymentService();
  }
}

abstract class APIBaseService {
  final String apiName;

  APIBaseService({required this.apiName});

  precheck() async {
    final sharedPreferenceInstance = await SharedPreferences.getInstance();
    if (sharedPreferenceInstance.getString(config['api']['KEY']['TOKEN']!) ==
        null) {
      return false;
    }
    return true;
  }

  static Future<Map<String, String>?> getCachedAuth() async {
    final sharedPreferenceInstance = await SharedPreferences.getInstance();
    if (sharedPreferenceInstance.getString(config['api']['KEY']['TOKEN']!) !=
        null) {
      return <String, String>{
        'token':
            sharedPreferenceInstance.getString(config['api']['KEY']['TOKEN']!)!,
        'refresh':
            sharedPreferenceInstance.getString(config['api']['KEY']['TOKEN']!)!
      };
    }
    return null;
  }
}

class UserService extends APIBaseService {
  late Uri url;
  UserService() : super(apiName: 'user') {
    url = Uri.parse('${config['api']['BASE_URL']}');
  }

  UserAccount toUserAccount(Map<String, Object?> object) {
    return UserAccount.fromMap(object);
  }

  static Future<void> clearAuthCache() async {
    final sharedPreferenceInstance = await SharedPreferences.getInstance();
    sharedPreferenceInstance.remove(config['api']['KEY']['TOKEN']!);
    sharedPreferenceInstance.remove(config['api']['KEY']['REFRESH_TOKEN']!);
  }

  static Future<void> setAuthCache(Map<String, dynamic> result) async {
    final sharedPreferenceInstance = await SharedPreferences.getInstance();
    sharedPreferenceInstance.setString(
        config['api']['KEY']['TOKEN']!, result['access_token']);
    sharedPreferenceInstance.setString(
        config['api']['KEY']['REFRESH_TOKEN']!, result['refresh_token']);
  }

  Future<UserAccount?> readProfile() async {
    final auth = await APIBaseService.getCachedAuth();
    if (auth == null) {
      return null;
    }
    // TODO : Change detail Path of readProfile
    final targetUrl = Uri.parse('$url/auth/profile');
    final response = await http
        .get(targetUrl, headers: {'Authorization': 'Bearer ${auth['token']!}'});
    if (response.statusCode == 401) {
      final refreshResult = await UserService.updateRefreshToken();
      if (refreshResult == true) {
        return await readProfile();
      }
      return null;
    }
    final result = JsonData.fromJson(response.body);
    return toUserAccount(result);
  }

  Future<bool> updateProfile(UserAccountUpdatableData data) async {
    final auth = await APIBaseService.getCachedAuth();
    if (auth == null) {
      return false;
    }
    // TODO : Change detail Path of updateProfile
    final targetUrl = Uri.parse('$url/user/${auth['uid']}');
    final response = await http.patch(targetUrl,
        body: data.toMap(),
        headers: {'Authorization': 'Bearer ${auth['token']!}'});
    if (response.statusCode == 401) {
      final refreshResult = await UserService.updateRefreshToken();
      if (refreshResult == true) {
        return await updateProfile(data);
      }
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    // TODO : Change detail Path of signup
    final targetUrl = Uri.parse('$url/auth/signup');
    final data = {'name': name, 'email': email, 'password': password};
    final response = await http.post(targetUrl, body: data);
    if (response.statusCode == 201) {
      final result = await login(email, password);
      return result;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    // TODO : Change detail Path of login
    final targetUrl = Uri.parse('$url/auth/login');
    final data = {'email': email, 'password': password};
    final response = await http.post(targetUrl, body: data);
    if (response.statusCode == 401) {
      return await UserService.updateRefreshToken();
    } else if (response.statusCode == 201) {
      final result = JsonData.fromJson(response.body);
      await UserService.setAuthCache(result);
      return true;
    }
    return false;
  }

  static Future<bool> updateRefreshToken() async {
    if (kDebugMode) {
      print('refresh start');
    }
    final auth = await APIBaseService.getCachedAuth();
    if (auth == null) {
      return false;
    }
    // TODO : Change detail Path of updateRefreshToken
    final targetUrl = Uri.parse('${config['api']['BASE_URL']}/auth/refresh');
    final refreshResponse = await http.post(targetUrl,
        headers: {'Authorization': 'Bearer ${auth['refresh']!}'});
    if (refreshResponse.statusCode != 201) {
      await UserService.clearAuthCache();
      return false;
    }
    final refreshResult = JsonData.fromJson(refreshResponse.body);
    await UserService.setAuthCache(refreshResult);
    return true;
  }

  Future<bool> deleteAccount(String email, String password) async {
    final auth = await APIBaseService.getCachedAuth();
    if (auth == null) {
      return false;
    }
    // TODO : Change detail Path of deleteAccount
    final targetUrl = Uri.parse('$url/auth/withdrawal');
    final data = {'email': email, 'password': password};
    final response = await http.delete(targetUrl,
        body: data, headers: {'Authorization': 'Bearer ${auth['token']!}'});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}

class PaymentService extends APIBaseService {
  late Uri url;
  PaymentService() : super(apiName: 'payment') {
    url = Uri.parse('${config['api']['BASE_URL']}/$apiName');
  }

  Future<bool> validate(dynamic data) async {
    final auth = await APIBaseService.getCachedAuth();
    if (auth == null) {
      return false;
    }
    // TODO : Change detail Path of payment validate
    final targetUrl = Uri.parse('$url/validate');
    final response =
        await http.post(targetUrl, body: jsonEncode(data), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      'Authorization': 'Bearer ${auth['token']!}'
    });
    final result = JsonData.fromJson(response.body);
    if (kDebugMode) {
      print(result);
    }
    if (result['validation'] == true) {
      return true;
    }
    return false;
  }
}
