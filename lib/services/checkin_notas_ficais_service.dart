import 'dart:convert';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> checkInNotasFiscais(
  String email,
  String password,
  int checkInId,
) async {
  var url = Uri.parse(ConstsApi.checkiNotaFiscal);

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
        'checkInId': checkInId.toString(),
      },
    ),
  );

  if (resposta.statusCode == 200) {
    return jsonDecode(utf8.decode(resposta.bodyBytes));
  } else {
    Map<String, dynamic> jsonResponse =
        jsonDecode(utf8.decode(resposta.bodyBytes));
    if (jsonResponse.containsKey('errors')) {
      List<dynamic> errors = jsonResponse['errors'];
      if (errors.isNotEmpty) {
        return {'errors': errors};
      }
    }
    return {
      'errors': ['Erro de servidor']
    };
  }
}
