import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/consts/app_consts.dart';

class EsqueciSenhaService {
  Future<Map<String, dynamic>> esqueciSenhaService({
    required String email,
  }) async {
    var url = Uri.parse(ConstsApi.esqueciSenha);

    var resposta = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (resposta.statusCode == 200) {
      return json.decode(utf8.decode(resposta.bodyBytes));
    } else {
      throw Exception('Erro ao verificar o token');
    }
  }
}
