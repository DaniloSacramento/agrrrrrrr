import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/services/divergencia_service.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';

class DivergenciaPage extends StatefulWidget {
  final List<int> selectedNotes;
  final String checkin;
  final String nf;

  const DivergenciaPage({
    Key? key,
    required this.selectedNotes,
    required this.checkin,
    required this.nf,
  }) : super(key: key);

  @override
  State<DivergenciaPage> createState() => _DivergenciaPageState();
}

class _DivergenciaPageState extends State<DivergenciaPage> {
  String? userPassword;
  String? userEmail;
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();
  int? selectedDivergenciaId;
  List<dynamic> divergencias = [];
  String? selectedDivergencia;
  bool isLoading = true;
  int _charCount = 0;
  final _observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserCredentials();
  }

  Future<void> _getUserCredentials() async {
    userPassword = await SharedPreferencesController.getUserPassword();
    userEmail = await SharedPreferencesController.getUserEmail();
    await _fetchDivergencias();
    setState(
      () {
        isLoading = false;
      },
    );
  }

  bool get _isFormValid {
    return (_formKey.currentState?.validate() ?? false) &&
        selectedDivergenciaId != null;
  }

  Future<void> _fetchDivergencias() async {
    if (userEmail != null && userPassword != null) {
      try {
        List<dynamic> response =
            await divergencia(email: userEmail!, password: userPassword!);
        setState(() {
          divergencias = response;
        });
      } catch (e) {
        setState(
          () {
            _errorMessage = 'Erro ao carregar divergências: $e';
          },
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar divergências: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Divergência',
                        style: TextStyle(
                          fontSize: 24,
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Text('Checkin: '),
                          Text(widget.checkin),
                          const Text(' / NF: '),
                          Text(widget.nf),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Divergência',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: darkBlueColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('Selecione uma divergência'),
                            value: selectedDivergencia,
                            isExpanded: true,
                            style: TextStyle(
                              color: darkBlueColor,
                              fontSize: 16,
                            ),
                            dropdownColor: Colors.white,
                            items: divergencias.map((divergencia) {
                              return DropdownMenuItem<String>(
                                value: divergencia['divergenciaId'].toString(),
                                child: Text(divergencia['divergenciaDesc']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(
                                () {
                                  selectedDivergencia = value;
                                  selectedDivergenciaId =
                                      divergencias.firstWhere((divergencia) =>
                                          divergencia['divergenciaId']
                                              .toString() ==
                                          value)['divergenciaId'];
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Observação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _observacaoController,
                        maxLines: 14,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          counterText: '$_charCount/600',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _charCount = value.length;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma observação.';
                          } else if (value.length > 600) {
                            return 'A observação não pode ter mais de 600 caracteres.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _observacaoController.clear();
              setState(
                () {
                  selectedDivergencia = null;
                  selectedDivergenciaId = null;
                },
              );
              Navigator.pop(context);
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.close),
          ),
          const SizedBox(
            width: 5,
          ),
          if (_isFormValid)
            FloatingActionButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  final result = await divergenciasRegistrar(
                    email: userEmail!,
                    password: userPassword!,
                    observacao: _observacaoController.text,
                    divergenciaId: selectedDivergenciaId!,
                    nfCompraIds: widget.selectedNotes,
                  );

                  setState(() {
                    isLoading = false;
                  });

                  if (result == null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Fecha a página
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Divergência registrada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    setState(() {
                      _errorMessage = result;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
            ),
        ],
      ),
    );
  }
}

Future<List<dynamic>> divergencia({
  required String email,
  required String password,
}) async {
  var url = Uri.parse(ConstsApi.divergenciasApp);
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
