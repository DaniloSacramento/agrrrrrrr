import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:http/http.dart' as http;

Future<String?> login(String email, String password) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = Uri.parse(ConstsApi.authUsuario);
  var resposta = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  if (resposta.statusCode == 200) {
    await sharedPreferences.setString('data', utf8.decode(resposta.bodyBytes));
  } else {
    Map<String, dynamic> jsonResponse =
        jsonDecode(utf8.decode(resposta.bodyBytes));
    if (jsonResponse.containsKey('errors')) {
      List<dynamic> errors = jsonResponse['errors'];
      if (errors.isNotEmpty) {
        return errors[0];
      }
    }
    return 'Erro desconhecido ao fazer login'; // Default error message
  }
}
