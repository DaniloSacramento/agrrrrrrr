import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/pages/chamado_page_visu_anexo.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:http/http.dart' as http;

class ChamadosPage extends StatefulWidget {
  const ChamadosPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChamadosPage> createState() => _ChamadosPageState();
}

class _ChamadosPageState extends State<ChamadosPage> {
  Future<List<dynamic>>? futureChamados;
  String? userPassword;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _initializeUserDetails();
  }

  Future<void> _initializeUserDetails() async {
    userPassword = await SharedPreferencesController.getUserPassword();
    userEmail = await SharedPreferencesController.getUserEmail();
    setState(
      () {
        futureChamados = chamadoHistorico(
          email: userEmail!,
          password: userPassword!,
        );
      },
    );
  }

  String formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (futureChamados == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: Center(
          child: Image.asset(
            'assets/iconAppTop.png',
            fit: BoxFit.contain,
            height: 150,
            width: 150,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histórico de Chamados',
              style: TextStyle(
                fontSize: 24,
                color: darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: futureChamados,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum chamado encontrado.'));
                  } else {
                    return GestureDetector(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var chamado = snapshot.data![index];
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChamadoVisuAnexo(
                                      chamado: chamado,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'NF',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            '${chamado['lojaDesc']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${chamado['nfCompraDesc']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            formatDateTime(chamado['dtCreate']),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Divider(color: Colors.grey[300]),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Produto',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${chamado['produtoDesc']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tipo de chamado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${chamado['chamadoTipoDesc']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${chamado['statusDesc']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Função de chamada da API
Future<List<dynamic>> chamadoHistorico({
  required String email,
  required String password,
}) async {
  var url = Uri.parse(ConstsApi.chamadoHistorico);
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
