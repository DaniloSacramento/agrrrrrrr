import 'dart:convert';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/model/checkin_model.dart';

Future<List<CheckIn>> checkin({
  required String email,
  required String password,
  required String filter,
}) async {
  var url = Uri.parse(ConstsApi.checkin);
  var resposta = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'filter': filter,
      'password': password,
    }),
  );

  if (resposta.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(resposta.bodyBytes));

    if (jsonResponse.containsKey('errors') &&
        jsonResponse['errors'].isNotEmpty) {
      throw Exception(jsonResponse['errors'][0]);
    }
    if (jsonResponse.containsKey('data')) {
      var dataList = jsonResponse['data'] as List;
      return dataList.map((item) => CheckIn.fromJson(item)).toList();
    } else {
      throw Exception('Erro desconhecido: dados não encontrados.');
    }
  } else {
    throw Exception('Erro desconhecido ao fazer check-in');
  }
}
