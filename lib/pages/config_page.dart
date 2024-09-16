// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/pages/alterar_senha_page.dart';
import 'package:trivia_checkin/pages/input_page.dart';
import 'package:trivia_checkin/pages/login_page.dart';
import 'package:trivia_checkin/services/excluir_conta_service.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool isSwitched = false;
  String? userPassword;
  String? userEmail;
  _getUserPassword() async {
    userPassword = await SharedPreferencesController.getUserPassword();
    setState(() {});
  }

  _getUserEmail() async {
    userEmail = await SharedPreferencesController.getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserPassword();
    _getUserEmail();
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sair do aplicativo?',
            style: GoogleFonts.dosis(
              textStyle: TextStyle(
                fontSize: 26,
                color: darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Tem certeza de que deseja sair do aplicativo?',
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text(
                'Sair',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () async {
                bool saiu = await sair();
                if (saiu) {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
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
      body: CustomPaint(
        painter: TrianguloPainter(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: telaHeight * 0.00,
              ),
              SizedBox(
                height: telaHeight * 0.05,
              ),
              Text(
                "Notificações",
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(
                height: telaHeight * 0.001,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Permitir notificações na tela bloqueada',
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: telaHeight * 0.03,
              ),
              Text(
                'Acesso',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(
                height: telaHeight * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlterarSenhaPage(),
                          ));
                    },
                    child: Text(
                      'Alterar senha',
                      style: GoogleFonts.dosis(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: telaHeight * 0.02,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      _showDeleteAccountConfirmationDialog(context);
                    },
                    child: Text(
                      'Excluir conta',
                      style: GoogleFonts.dosis(
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellowColor,
        onPressed: () async {
          _showExitConfirmationDialog(context);
        },
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountConfirmationDialog(
      BuildContext context) async {
    bool confirmDelete = false;
    bool isDeleteAccountChecked = false;
    String errorMessage = '';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Excluir Minha Conta',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 26,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Todos os seus dados serão apagados, deseja continuar?',
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isDeleteAccountChecked,
                        onChanged: (value) {
                          setState(
                            () {
                              isDeleteAccountChecked = value ?? false;
                              confirmDelete = isDeleteAccountChecked;
                            },
                          );
                        },
                      ),
                      Text(
                        'Estou ciente dessa ação',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (confirmDelete)
                  TextButton(
                    child: Text(
                      'Confirmar',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(
                          fontSize: 17,
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      String? delete = await excluirConta(
                          email: userEmail!, password: userPassword!);
                      if (delete != null) {
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputPage(),
                          ),
                        );
                      } else {
                        setState(() {
                          errorMessage =
                              'Erro ao excluir conta. Tente novamente!';
                        });
                      }
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> sair() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }
}
