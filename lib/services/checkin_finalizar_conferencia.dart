import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:http/http.dart' as http;

Future<String?> checkInFinalizarConferencia({
  required String email,
  required String password,
  required int checkInId,
  required String observacao,
}) async {
  var url = Uri.parse(ConstsApi.checkinFinalizarConferencia);

  var resposta = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'checkInId': checkInId.toString(),
      'observacao': observacao,
    }),
  );
  if (resposta.statusCode == 200) {
    jsonDecode(utf8.decode(resposta.bodyBytes));
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
