import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/model/usuario_model.dart';
import 'package:trivia_checkin/navigation_menu.dart';
import 'package:trivia_checkin/pages/divergencia_page.dart';
import 'package:trivia_checkin/pages/itens_page.dart';
import 'package:trivia_checkin/services/checkin_finalizar_conferencia.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';

class ConferenciaPage extends StatefulWidget {
  final dynamic item;
  final dynamic handleCheckin;
  const ConferenciaPage(
      {super.key, required this.item, required this.handleCheckin});

  @override
  State<ConferenciaPage> createState() => _ConferenciaPageState();
}

class _ConferenciaPageState extends State<ConferenciaPage> {
  final _observacaoController = TextEditingController();
  late List<List<bool>> itemSelections;
  bool showCheckboxes = false;
  String? userPassword;
  String? userEmail;
  UsuarioModel? user;
  bool isWarningActive = true;

  _getUserPassword() async {
    userPassword = await SharedPreferencesController.getUserPassword();
    setState(() {});
  }

  _getUserEmail() async {
    userEmail = await SharedPreferencesController.getUserEmail();
    setState(() {});
  }

  void _toggleCheckboxes() {
    setState(() {
      showCheckboxes = !showCheckboxes;
      isWarningActive = !isWarningActive;
    });
  }

  void _navigateWithSelectedNotes() {
    List<int> uniqueSelectedNotes = [];
    Set<String> nfNumbers = {};

    for (var i = 0; i < itemSelections.length; i++) {
      for (var j = 0; j < itemSelections[i].length; j++) {
        if (itemSelections[i][j]) {
          var nota = widget.item['notas'][i];
          if (nota != null &&
              nota['itens'] != null &&
              nota['itens'][j] != null) {
            if (!uniqueSelectedNotes.contains(nota['id'])) {
              uniqueSelectedNotes.add(nota['id']);
              nfNumbers.add(nota['numNf'] ?? '');
            }
          }
        }
      }
    }

    if (uniqueSelectedNotes.isNotEmpty && nfNumbers.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DivergenciaPage(
            selectedNotes: uniqueSelectedNotes,
            checkin: widget.item['id'].toString(),
            nf: nfNumbers.join(', '),
          ),
        ),
      );
    } else {
      // Optional: Show a message indicating no notes are selected
    }

    setState(() {
      itemSelections = List.generate(
        widget.item['notas'].length,
        (index) => List<bool>.generate(
          widget.item['notas'][index]['itens'].length,
          (itemIndex) => false,
        ),
      );
      showCheckboxes = false;
    });
  }

  @override
  void initState() {
    super.initState();
    itemSelections = List.generate(
      widget.item['notas'].length,
      (index) => List<bool>.generate(
        widget.item['notas'][index]['itens'].length,
        (itemIndex) => false,
      ),
    );
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
            'Finalizar Conferência',
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
                  'Deseja confirmar?',
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  'Observacao',
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextField(
                  controller: _observacaoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite sua observação aqui',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Não',
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
                  'Sim',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(
                      fontSize: 17,
                      color: darkBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () async {
                  var checkInId = widget.item['notas'].isNotEmpty
                      ? widget.item['notas'][0]['checkInId']
                      : null;
                  checkInFinalizarConferencia(
                    email: userEmail!,
                    password: userPassword!,
                    checkInId: checkInId,
                    observacao: _observacaoController.text,
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationMenu(
                        initialHomePage: InitialHomePage.checkins,
                      ),
                    ),
                    (r) => false,
                  );
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
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
          padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conferência',
                style: TextStyle(
                  fontSize: 24,
                  color: darkBlueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Checkin: ${item['id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['fornecedorDesc'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Veiculo',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          item['veiculoPlaca'],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Loja',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Doca',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item['lojaDesc']}',
                            ),
                            Text(
                              '${item['docaDesc']}',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'Notas',
                style: TextStyle(
                  fontSize: 20,
                  color: darkBlueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: item['notas'].length,
                  itemBuilder: (context, index) {
                    var nota = item['notas'][index];
                    double totalVolume = 0;
                    for (var item in nota['itens']) {
                      totalVolume += item['qtdCompra'];
                    }

                    String formattedVolume = totalVolume % 1 == 0
                        ? totalVolume.toInt().toString()
                        : totalVolume.toStringAsFixed(2);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showCheckboxes)
                                  Checkbox(
                                    value: itemSelections[index].isNotEmpty
                                        ? itemSelections[index][0]
                                        : false,
                                    onChanged: (value) {
                                      setState(() {
                                        itemSelections[index] = List.generate(
                                          itemSelections[index].length,
                                          (itemIndex) => value ?? false,
                                        );
                                      });
                                    },
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Nota',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                '${nota['numNf']}',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'N.Pedido',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                nota['numPedCompra'] != null
                                                    ? '${nota['numPedCompra']}'
                                                    : '',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'Volume',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                formattedVolume,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${nota['statusDesc']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[700],
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItensPage(
                                                        item: nota,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.list,
                                                      color: Colors.yellow[800],
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Itens',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.yellow[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'checkboxTag',
            onPressed: _toggleCheckboxes,
            backgroundColor: isWarningActive ? yellowColor : Colors.red,
            child: Icon(
              isWarningActive ? Icons.warning : Icons.close,
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'finalizarNota',
            onPressed: () {
              if (showCheckboxes) {
                _navigateWithSelectedNotes();
              } else {
                _showExitConfirmationDialog(context);
              }
            },
            backgroundColor: isWarningActive ? Colors.green : Colors.green,
            child: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
