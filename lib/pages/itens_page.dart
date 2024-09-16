import 'package:flutter/material.dart';
import 'package:trivia_checkin/pages/chamado_page_item.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:intl/intl.dart';

class ItensPage extends StatefulWidget {
  final dynamic item;
  const ItensPage({Key? key, required this.item}) : super(key: key);

  @override
  State<ItensPage> createState() => _ItensPageState();
}

class _ItensPageState extends State<ItensPage> {
  bool isLoading = true;
  late dynamic nota;

  @override
  void initState() {
    super.initState();
    nota = widget.item;
  }

  String formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  String formatQtdCompra(double qtdCompra) {
    if (qtdCompra == qtdCompra.toInt()) {
      return qtdCompra.toInt().toString();
    } else {
      return qtdCompra.toStringAsFixed(
        1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            indicatorColor: yellowColor,
            labelColor: yellowColor,
            unselectedLabelColor: yellowColor,
            onTap: (index) {},
            tabs: const [
              Tab(
                text: 'Itens',
                icon: Icon(
                  Icons.list,
                ),
              ),
              Tab(
                text: 'Divergências',
                icon: Icon(
                  Icons.warning,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (nota != null && nota['itens'] != null) ...[
                    Row(
                      children: [
                        Text(
                          'NF ${nota['numNf']}',
                          style: TextStyle(
                            fontSize: 24,
                            color: darkBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('-'),
                        Text(
                          '${nota['serieNf']}',
                          style: TextStyle(
                            fontSize: 24,
                            color: darkBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Checkin ${nota['checkInId']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Clique em algum item para abrir um chamado',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: nota['itens'].length,
                        itemBuilder: (context, itemIndex) {
                          var itemNota = nota['itens'][itemIndex];
                          return Builder(builder: (
                            context,
                          ) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  var chamadoItem = {
                                    'id': nota['id'],
                                    'notas': [
                                      {
                                        'checkInId': nota['checkInId'],
                                        'id': nota['id'],
                                        'itens': [itemNota]
                                      }
                                    ]
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChamadoPageItem(
                                        item: chamadoItem,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            itemNota['produtoId'].toString(),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${formatQtdCompra(itemNota['qtdCompra'])} ${itemNota['unidadeCompra']}',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${itemNota['produtoDesc']}',
                                        style: const TextStyle(
                                            fontSize: 19,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${itemNota['categoriaDesc']}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'Nenhum item disponível',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'NF ${nota['numNf']}',
                        style: TextStyle(
                          fontSize: 24,
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('-'),
                      Text(
                        '${nota['serieNf']}',
                        style: TextStyle(
                          fontSize: 24,
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Checkin: ${nota['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 20),
                  if (nota != null &&
                      nota['divergencias'] != null &&
                      nota['divergencias'].isNotEmpty) ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: nota['divergencias'].length,
                        itemBuilder: (context, divergenciaIndex) {
                          var divergencia =
                              nota['divergencias'][divergenciaIndex];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    divergencia['divergenciaDesc'],
                                    style: const TextStyle(
                                        fontSize: 19,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${divergencia['observacao']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatDateTime(divergencia['dtCreate']),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${divergencia['userCreateNome']}')
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '${divergencia['statusDesc']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'Nenhuma divergência disponível',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
