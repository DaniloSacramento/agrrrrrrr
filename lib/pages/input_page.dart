import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trivia_checkin/pages/login_page.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: telaHeight * 0.2,
            ),
            const Text(
              "TRIVIA CHECKIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            SizedBox(
              height: telaHeight * 0.3,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const LoginPage(),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                child: const Text(
                  "Ir para o Login",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
