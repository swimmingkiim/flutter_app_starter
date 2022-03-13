import 'base-model.dart';

class UserAccount extends BaseModel {
  late int? id;
  late String name;
  late String email;

  UserAccount({
    this.id,
    required this.name,
    required this.email,
  });

  UserAccount.fromMap(Map<String, Object?> data) {
    id = int.parse(data[UserAccountFields.id].toString());
    name = data[UserAccountFields.name].toString();
    email = data[UserAccountFields.email].toString();
  }

  @override
  Map<String, Object?> toMap({bool? stringify}) {
    return <String, Object?>{
      UserAccountFields.id: id,
      UserAccountFields.name: name,
      UserAccountFields.email: email,
    };
  }

  updateFromMap(Map<String, Object?> data) {
    id = int.parse(data[UserAccountFields.id].toString());
    name = data[UserAccountFields.name].toString();
    email = data[UserAccountFields.email].toString();
  }
}

class UserAccountFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
}

class UserAccountUpdatableData {
  final String? name;
  final String? password;
  UserAccountUpdatableData({this.name, this.password});

  Map<String, Object?> toMap({bool? stringify}) {
    Map<String, Object?> result = {};
    if (name != null) {
      result[UserAccountFields.name] = name;
    }
    if (password != null) {
      result['password'] = password;
    }
    return result;
  }
}
