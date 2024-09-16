import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trivia_checkin/consts/app_consts.dart';

Future<List<dynamic>> chamadoTiposService({
  required String email,
  required String password,
}) async {
  var url = Uri.parse(ConstsApi.chamadosTipos);
  var resposta = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(
      <String, String>{
        'email': email,
        'password': password,
      },
    ),
  );

  if (resposta.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
        jsonDecode(utf8.decode(resposta.bodyBytes));
    if (jsonResponse.containsKey('data')) {
      return jsonResponse['data'];
    }
  } else {
    Map<String, dynamic> jsonResponse =
        jsonDecode(utf8.decode(resposta.bodyBytes));
    if (jsonResponse.containsKey('errors')) {
      List<dynamic> errors = jsonResponse['errors'];
      if (errors.isNotEmpty) {
        throw Exception(errors[0]);
      }
    }
    throw Exception('Erro de servidor');
  }

  return [];
}
