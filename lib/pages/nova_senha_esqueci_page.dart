// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trivia_checkin/pages/sucesso_page.dart';
import 'package:trivia_checkin/services/nova_senha_service.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';

class NovaSenha extends StatefulWidget {
  final String email;
  const NovaSenha({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<NovaSenha> createState() => _NovaSenhaState();
}

class _NovaSenhaState extends State<NovaSenha> {
  TextEditingController senhaNova = TextEditingController();
  TextEditingController confirmarSenha = TextEditingController();
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  String? _validatePasswordMatch(String value) {
    if (value != senhaNova.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  String errorMessage = '';
  bool isLoading = false;
  bool validarSenha(String senha) {
    if (senha.length < 6) {
      return false;
    }

    if (!senha.contains(RegExp(r'\d'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    if (senha.contains(RegExp(r'\s'))) {
      return false;
    }

    return true;
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Adicione sua nova senha:',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    color: darkBlueColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  'Senha',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: darkBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: senhaNova,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha.';
                  }
                  return null;
                },
                obscureText: _showPassword == false ? true : false,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  suffixIcon: GestureDetector(
                    child: Icon(
                        _showPassword == false
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey),
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  hintText: "Senha",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  'Confirmar Senha',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: darkBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: confirmarSenha,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha.';
                  }
                  if (_validatePasswordMatch(value) != null) {
                    return 'Senhas diferentes';
                  }
                  return null;
                },
                obscureText: _showPassword == false ? true : false,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  suffixIcon: GestureDetector(
                    child: Icon(
                        _showPassword == false
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey),
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  hintText: "Confirmar senha",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoading = true;
                            });

                            bool apiSuccess = await NovaSenhaService()
                                .novaSenha(
                                    passwordNew: senhaNova.text,
                                    email: widget.email);
                            if (!apiSuccess) {
                              setState(() {
                                errorMessage =
                                    'Algo de errado aconteceu! Tente novamente mais tarde.';
                              });
                            }
                            setState(() {
                              isLoading = false;
                            });
                            if (apiSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SucessoPage(),
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator() // Mostrar indicador de carregamento
                      : const Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
