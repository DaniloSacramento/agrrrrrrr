import 'dart:convert';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:http/http.dart' as http;

Future<String?> chamadoHistoricoService({
  required String email,
  required String password,
}) async {
  var url = Uri.parse(
    ConstsApi.chamadoHistorico,
  );

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
    jsonDecode(utf8.decode(resposta.bodyBytes));
  } else {
    Map<String, dynamic> jsonResponse = jsonDecode(
      utf8.decode(
        resposta.bodyBytes,
      ),
    );
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
