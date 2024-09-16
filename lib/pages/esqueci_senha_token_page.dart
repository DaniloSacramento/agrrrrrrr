// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:trivia_checkin/pages/login_page.dart';
import 'package:trivia_checkin/pages/nova_senha_esqueci_page.dart';
import 'package:trivia_checkin/services/esqueci_senha_token_service.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';

class EsqueciSenhaToken extends StatefulWidget {
  final String email;
  const EsqueciSenhaToken({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<EsqueciSenhaToken> createState() => _EsqueciSenhaTokenState();
}

class _EsqueciSenhaTokenState extends State<EsqueciSenhaToken> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isCodeComplete = false;
  bool apiSuccess = false;
  final FocusNode _pinPutFocusNode = FocusNode();
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  //OtpTimerButtonController controller = OtpTimerButtonController();
  TextEditingController otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _pinPutFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: yellowColor),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.grey[300],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: Image.asset(
          'assets/iconAppTop.png',
          fit: BoxFit.contain,
          height: 150,
          width: 150,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: telaHeight * 0.015,
              ),
              Text(
                "Informe o Token que foi enviado\npara seu E-mail!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkBlueColor,
                ),
              ),
              SizedBox(
                height: telaHeight * 0.030,
              ),
              Pinput(
                length: 6,
                controller: otpController,
                focusedPinTheme: focusedPinTheme,
                focusNode: _pinPutFocusNode,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onChanged: (code) {
                  setState(() {
                    isCodeComplete = code.length == 6;
                  });
                },
              ),
              SizedBox(
                height: telaHeight * 0.05,
              ),
              Center(
                child: Column(
                  children: [
                    isCodeComplete
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellowColor,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                apiResponse = await EsqueciSenhaServiceToken()
                                    .esqueciSenhaServiceToken(
                                        token: otpController.text,
                                        email: widget.email);
                                if (apiResponse!['data'] == 'ok') {
                                  apiSuccess = true;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NovaSenha(email: widget.email),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    errorMessage = apiResponse!['errors'][0];
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  errorMessage = 'Erro ao processar o pedido';
                                });
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Text(
                              'Continuar',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : Container(),
                    SizedBox(
                        height:
                            16), // Adiciona um espaço entre o botão e a mensagem de erro
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
