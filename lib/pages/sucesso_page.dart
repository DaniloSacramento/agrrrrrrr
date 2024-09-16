import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trivia_checkin/pages/login_page.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';

class SucessoPage extends StatefulWidget {
  const SucessoPage({super.key});

  @override
  State<SucessoPage> createState() => _SucessoPageState();
}

class _SucessoPageState extends State<SucessoPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
      body: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: TrianguloPainter(),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.4,
                  width: 350,
                  child: Image.asset(
                    'assets/legal.png',
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                Text('Maravilha',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkBlueColor,
                      ),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Seus dados foram alterados com sucesso',
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: screenHeight * 0.2,
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
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Voltar',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
