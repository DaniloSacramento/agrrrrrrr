import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trivia_checkin/pages/chamados_page.dart';
import 'package:trivia_checkin/pages/config_page.dart';
import 'package:trivia_checkin/pages/home_page.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';

enum InitialHomePage {
  config,
  checkins,
  chamados,
}

extension InitialHomePageExt on InitialHomePage {
  bool get isConfig => this == InitialHomePage.config;
  bool get isChamados => this == InitialHomePage.chamados;
  bool get isCheckins => this == InitialHomePage.checkins;
}

class NavigationMenu extends StatefulWidget {
  final InitialHomePage? initialHomePage;
  const NavigationMenu({super.key, this.initialHomePage});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int intemSelecionado = 0;
  static TextStyle labelStyle = GoogleFonts.dosis(
    textStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
  @override
  void initState() {
    if (widget.initialHomePage != null) {
      switch (widget.initialHomePage!) {
        case InitialHomePage.config:
          intemSelecionado = 2;
          break;
        case InitialHomePage.checkins:
          intemSelecionado = 0;
          break;
        case InitialHomePage.chamados:
          intemSelecionado = 1;
          break;
        default:
      }
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: intemSelecionado,
        children: const [
          HomePage(),
          ChamadosPage(),
          ConfigPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: intemSelecionado,
        backgroundColor: darkBlueColor,
        unselectedItemColor: Colors.grey,
        fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Checkins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_outlined),
            label: 'Chamados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Configurações",
          ),
        ],
        selectedLabelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        onTap: (valor) {
          setState(
            () {
              intemSelecionado = valor;
            },
          );
        },
      ),
    );
  }
}
