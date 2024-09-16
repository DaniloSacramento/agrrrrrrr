import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/model/usuario_model.dart';

class SharedPreferencesController {
  static Future<void> saveUser(UsuarioModel user) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String userData = jsonEncode(user.toMap());
    await sharedPreferences.setString('data', userData);
  }

  static Future<UsuarioModel?> getUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    if (result != null) {
      final map = jsonDecode(result);
      if (map != null && map['data'] != null) {
        return UsuarioModel.fromMap(map['data']);
      }
    }
    return null;
  }

  static Future<bool> delete() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.remove('data');
    return true;
  }

  static Future<bool> clear() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }

  static Future<String?> getUrl() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString('get_url');
  }

  static Future<String?> getUserPassword() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString('user_password');
  }

  static Future<String?> getUserEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString('user_email');
  }
}
