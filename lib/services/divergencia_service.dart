import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:http/http.dart' as http;

Future<String?> divergenciasRegistrar({
  required String email,
  required String password,
  required String observacao,
  required int divergenciaId,
  required List<int> nfCompraIds,
}) async {
  var url = Uri.parse(ConstsApi.divergenciaRegistrar);

  try {
    var resposta = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'observacao': observacao,
        'divergenciaId': divergenciaId,
        'nfCompraIds': nfCompraIds,
      }),
    );

    print('Response status: ${resposta.statusCode}');
    print('Response body: ${utf8.decode(resposta.bodyBytes)}');

    if (resposta.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(resposta.bodyBytes));
      if (jsonResponse.containsKey('data') && jsonResponse['data'] != null) {
        if (jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
          return null;
        } else {
          return 'Erro: ${jsonResponse['errors'].isNotEmpty ? jsonResponse['errors'][0] : 'Erro desconhecido'}';
        }
      } else {
        return 'Erro: ${jsonResponse['errors']?.isNotEmpty == true ? jsonResponse['errors'][0] : 'Erro desconhecido'}';
      }
    } else {
      return 'Erro de servidor: Código ${resposta.statusCode}';
    }
  } catch (e) {
    return 'Erro inesperado: $e';
  }
}
