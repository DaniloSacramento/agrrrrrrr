import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:http/http.dart' as http;

Future<String?> excluirFotoAnexo({
  required String email,
  required String password,
  required String chamadoId,
  required String chamadoAnexoId,
}) async {
  var url = Uri.parse(ConstsApi.excluirFoto);

  var resposta = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'chamadoId': chamadoId,
      'chamadoAnexoId': 'chamadoAnexoId',
    }),
  );
  if (resposta.statusCode == 200) {
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
