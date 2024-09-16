import 'package:flutter/material.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/pages/esqueci_senha_token_page.dart';
import 'package:trivia_checkin/services/esqueci_senha_service.dart';
import 'package:trivia_checkin/services/esqueci_senha_token_service.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';
import 'package:trivia_checkin/widgets/validar_email_widgets.dart';

class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

final _emailController = TextEditingController();
final _formKey = GlobalKey<FormState>();
ValidarEmail validarEmail = ValidarEmail();
String? userEmail;
String? errorMessage;
Map<String, dynamic>? apiResponse;

class _EsqueciSenhaState extends State<EsqueciSenha> {
  _getUserEmail() async {
    userEmail = await SharedPreferencesController.getUserEmail();
    setState(() {});
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Text(
                  "Esqueceu?\nTudo bem.",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkBlueColor,
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.030,
                ),
                const Text(
                  'Digite seu endereco de e-mail para redefinir sua senha. Enviaremos um e-mail com o passo a passo, portanto, não esqueça de conferir\ntambém a sua caixa de spam.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.020,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (email) => ValidarEmail.validarEmail(email),
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    hintText: "E-mail",
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
                SizedBox(
                  height: telaHeight * 0.080,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      apiResponse = await EsqueciSenhaService()
                          .esqueciSenhaService(email: _emailController.text);
                      if (apiResponse!['data'] == 'ok') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EsqueciSenhaToken(
                              email: _emailController.text,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          errorMessage = apiResponse!['errors'][0];
                        });
                      }
                    }
                  },
                  child: const Text(
                    "Redefinir minha senha",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                errorMessage != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
