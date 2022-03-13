import 'service.dart';

class APIRepository {
  APIService _service = APIService();

  APIRepository();

  static Future<APIRepository> create() async {
    final instance = APIRepository();
    return instance;
  }

  APIService get service {
    return _service;
  }
}
