import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/model/loja_model.dart';
import 'package:trivia_checkin/model/usuario_model.dart';
import 'package:trivia_checkin/pages/conferencia_page.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userPassword;
  List<dynamic> checkinData = [];

  List<dynamic> lojas = [];
  UsuarioModel? user;
  String? errorMessage;
  dynamic selectedLoja;
  final _controllerEvents = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getUser();
        _getUserPassword();
      },
    );
  }

  _getUserPassword() async {
    userPassword = await SharedPreferencesController.getUserPassword();
    setState(() {});
  }

  _getUser() async {
    user = await SharedPreferencesController.getUser();
    print("User data: ${user.toString()}");
    setState(() {});
  }

  Future<List<dynamic>?> checkin({
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
        return jsonResponse['data'] as List<dynamic>;
      } else {
        throw Exception('Erro desconhecido: dados não encontrados.');
      }
    } else {
      throw Exception('Erro desconhecido ao fazer check-in');
    }
  }

  _handleCheckin() async {
    setState(
      () {
        isLoading = true;
        errorMessage = null;
      },
    );
    try {
      var response = await checkin(
        email: user!.email,
        password: userPassword.toString(),
        filter: _controllerEvents.text,
      );

      if (response != null && response.isEmpty) {
        setState(
          () {
            errorMessage = 'Nenhum registro foi encontrado';
          },
        );
      } else {
        setState(() {
          checkinData = response ?? [];
        });
      }
      _controllerEvents.clear();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    onPressedSearch() async {
      setState(() {
        isLoading = true;
      });

      var registrarNf = await checkin(
        email: user!.email,
        password: userPassword.toString(),
        filter: _controllerEvents.text,
      );

      setState(() {
        isLoading = false;
      });

      if (registrarNf != null) {
        _controllerEvents.clear();
      } else {
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        actions: [
          IconButton(
            onPressed: () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(
                    scanType: ScanType.barcode,
                  ),
                ),
              );
              setState(
                () {
                  if (res is String && res != "-1") {
                    _controllerEvents.text = res;
                    onPressedSearch();
                  }
                },
              );
              _controllerEvents.clear();
            },
            icon: const Icon(Icons.camera_alt),
          ),
        ],
        title: Center(
          child: Image.asset(
            'assets/iconAppTop.png',
            fit: BoxFit.contain,
            height: 150,
            width: 150,
          ),
        ),
      ),
      body: CustomPaint(
        painter: TrianguloPainter(),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  'Checkins em conferência',
                  style: TextStyle(
                    fontSize: 24,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Número NF ou Chave NF',
                    filled: true,
                    fillColor: Colors.grey[300],
                    prefixIcon: Icon(
                      Icons.receipt_long,
                      color: darkBlueColor,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: _handleCheckin,
                        icon: Icon(Icons.search, color: darkBlueColor),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 28,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 12.0,
                    ),
                  ),
                  controller: _controllerEvents,
                  style: TextStyle(
                    color: darkBlueColor,
                    fontSize: 16,
                  ),
                ),
              ),
              if (errorMessage !=
                  null) // Exibe a mensagem de erro ou 'nenhum item encontrado'
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (isLoading) // Exibe o indicador de carregamento
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              checkinData.isEmpty
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: checkinData.length,
                        itemBuilder: (context, index) {
                          var item = checkinData[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConferenciaPage(
                                    item: item,
                                    handleCheckin: _handleCheckin,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Checkin',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${item['id']}',
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Veículo',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                item['veiculoPlaca'],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Loja',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${item['lojaDesc']}',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Fornecedor',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        item['fornecedorDesc'],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Doca',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${item['docaDesc']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
