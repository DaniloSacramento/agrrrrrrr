import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trivia_checkin/pages/esqueci_senha_page.dart';
import 'package:trivia_checkin/services/alterar_senha_service.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  TextEditingController confirmarSenha = TextEditingController();
  TextEditingController senhaAtual = TextEditingController();
  TextEditingController novaSenha = TextEditingController();

  String? _validatePasswordMatch(String value) {
    if (value != novaSenha.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

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

  String errorMessage = '';

  bool isLoading = false;
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alterar Senha',
                        style: TextStyle(
                          fontSize: 24,
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          'Senha atual',
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(
                                fontSize: 18,
                                color: darkBlueColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: senhaAtual,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha.';
                          }
                          if (!validarSenha(value)) {
                            return 'A senha não atende aos critérios de validação.';
                          }
                          return null; // A senha é válida
                        },
                        obscureText: _showPassword == false ? true : false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
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
                          hintText: 'Senha atual',
                          hintStyle: GoogleFonts.dosis(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  'Nova Senha',
                                  style: GoogleFonts.dosis(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            TextFormField(
                              controller: novaSenha,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira uma senha.';
                                }
                                if (!validarSenha(value)) {
                                  return 'A senha não atende aos critérios de validação.';
                                }
                                return null; // A senha é válida
                              },
                              obscureText:
                                  _showPassword == false ? true : false,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
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
                                hintText: 'Nova senha',
                                hintStyle: GoogleFonts.dosis(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          controller: confirmarSenha,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma senha.';
                            }
                            if (!validarSenha(value)) {
                              return 'A senha não atende aos critérios de validação.';
                            }
                            if (_validatePasswordMatch(value) != null) {
                              return 'Senhas diferentes';
                            }

                            return null; // A senha é válida
                          },
                          obscureText: _showPassword == false ? true : false,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
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
                            hintText: 'Nova Senha',
                            hintStyle: GoogleFonts.dosis(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 5, 8, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Regras para criação da senha',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    '• Conter pelo menos 6 caracteres',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter ao menos um dígito',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter uma letra minúscula',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter uma letra maiúscula',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Conter um caractere especial ',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '• Nao conter nenhum espaco em branco',
                                    style: GoogleFonts.dosis(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.020,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellowColor,
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                alterarSenhaService(
                                    email: userEmail!,
                                    passwordNew: novaSenha.text,
                                    passwordOld: senhaAtual.text);
                              }
                              novaSenha.clear();
                              confirmarSenha.clear();
                              senhaAtual.clear();
                            },
                      child: isLoading
                          ? const CircularProgressIndicator() // Mostrar indicador de carregamento
                          : Text(
                              'Confirmar',
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
