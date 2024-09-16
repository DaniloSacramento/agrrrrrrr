import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:trivia_checkin/navigation_menu.dart';
import 'package:trivia_checkin/pages/esqueci_senha_page.dart';
import 'package:trivia_checkin/services/login_service.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';
import 'package:trivia_checkin/widgets/validador_senha_widgets.dart';
import 'package:trivia_checkin/widgets/validar_email_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _urlController = TextEditingController();
bool _showPassword = false;
bool _isLoading = false;
String? errorMessage;
ValidarSenha validarSenha = ValidarSenha();
ValidarEmail validarEmail = ValidarEmail();

class _LoginPageState extends State<LoginPage> {
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: telaHeight * 0.02,
                  ),
                  Text(
                    "Seja, bem-vindo!",
                    style: TextStyle(
                      fontSize: 24,
                      color: darkBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: telaHeight * 0.03,
                  ),
                  TextFormField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                      ),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) => ValidarEmail.validarEmail(email)),
                  SizedBox(
                    height: telaHeight * 0.01,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                        borderSide: BorderSide.none,
                      ),
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
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                    ),
                    obscureText: _showPassword == false ? true : false,
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha.';
                      }
                      if (!validarSenha.validarSenha(value)) {
                        return 'A senha não atende aos critérios de validação.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: telaHeight * 0.01,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Digite a URL ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(
                        Icons.link,
                        color: Colors.grey,
                      ),
                    ),
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    validator: (url) {
                      if (url == null || url.isEmpty) {
                        return 'Por favor, insira uma URL.';
                      }
                      // Verifica se a URL começa com http ou https
                      if (!url.startsWith('http')) {
                        return 'Insira uma URL válida.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EsqueciSenha(),
                            ),
                          );
                        },
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: telaHeight * 0.02,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              setState(
                                () {
                                  _isLoading = true;
                                },
                              );

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setString(
                                  'baseUrl', _urlController.text);

                              ConstsApi.updateBaseUrl(_urlController.text);

                              FocusScopeNode currentFocus =
                                  // ignore: use_build_context_synchronously
                                  FocusScope.of(context);
                              String? deuCerto = await login(
                                  _emailController.text,
                                  _passwordController.text);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (deuCerto == null) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                  'user_password',
                                  _passwordController.text,
                                );
                                await prefs.setString(
                                  'user_email',
                                  _emailController.text,
                                );
                                await prefs.setString(
                                  'get_url',
                                  _urlController.text,
                                );
                                Navigator.pushReplacement(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NavigationMenu(
                                      initialHomePage: InitialHomePage.checkins,
                                    ),
                                  ),
                                );
                              } else {
                                setState(
                                  () {
                                    errorMessage = deuCerto;
                                  },
                                );

                                _passwordController.clear();
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Entrar',
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                  ),
                  SizedBox(
                    height: telaHeight * 0.020,
                  ),
                  Center(
                    child: errorMessage != null
                        ? Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
