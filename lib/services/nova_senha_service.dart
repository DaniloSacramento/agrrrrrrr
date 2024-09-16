import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trivia_checkin/consts/app_consts.dart';

class NovaSenhaService {
  Future<bool> novaSenha({
    required String passwordNew,
    required String email,
  }) async {
    var url = Uri.parse(
      ConstsApi.novaSenhaServiceEsqueci,
    );

    var resposta = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'passwordNew': passwordNew,
      }),
    );
    if (resposta.statusCode == 200) {
      var decodedResponse = json.decode(utf8.decode(resposta.bodyBytes));

      return decodedResponse['ok'] == true;
    } else {
      return false;
    }
  }
}
