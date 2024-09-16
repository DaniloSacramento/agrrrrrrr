import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trivia_checkin/consts/app_consts.dart';

Future<String?> excluirConta({
  required String email,
  required String password,
}) async {
  var url = Uri.parse(ConstsApi.excluirConta);
  var resposta = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'email': email,
          'password': password,
        },
      ));
  if (resposta.statusCode == 200) {
    print('deu certo');
  } else {
    Map<String, dynamic> jsonResponse =
        jsonDecode(utf8.decode(resposta.bodyBytes));
    if (jsonResponse.containsKey('errors')) {
      List<dynamic> errors = jsonResponse['errors'];
      if (errors.isNotEmpty) {
        return errors[0];
      }
    }
    return 'Erro de servidor';
  }
  return null;
}
