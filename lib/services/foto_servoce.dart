import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:trivia_checkin/consts/app_consts.dart';

class AlterarFoto {
  Future<String?> fotoPromotor(
      {required int chamadoId, required Uint8List file}) async {
    Map<String, String> headers = {
      'authorization': ConstsApi.basicAuth,
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ConstsApi.foto),
    );

    request.headers.addAll(headers);
    request.files.add(http.MultipartFile.fromBytes("file", file,
        filename: "image.jpg", contentType: MediaType.parse("image/jpg")));
    request.fields.addAll({'chamadoId': chamadoId.toString()});

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print(
            'Resposta da API: $responseBody'); // Debug: Print the entire response
        final jsonResponse = jsonDecode(responseBody);
        final url = jsonResponse["data"];
        print('URL retornada: $url'); // Debug: Print the URL
        return url;
      } else {
        print('Erro ao enviar foto. StatusCode: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao enviar foto: $e');
      return null;
    }
  }
}
