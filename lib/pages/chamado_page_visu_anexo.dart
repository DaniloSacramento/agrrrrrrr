import 'package:flutter/material.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/services/excluir_foto.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';

class ChamadoVisuAnexo extends StatefulWidget {
  final dynamic chamado;

  const ChamadoVisuAnexo({super.key, required this.chamado});

  @override
  _ChamadoVisuAnexoState createState() => _ChamadoVisuAnexoState();
}

class _ChamadoVisuAnexoState extends State<ChamadoVisuAnexo> {
  late List<dynamic>? anexos;
  String? userPassword;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _getUserPassword();
    _getUserEmail();
    anexos = widget.chamado['anexos'];
  }

  _getUserPassword() async {
    userPassword = await SharedPreferencesController.getUserPassword();
    setState(() {});
  }

  _getUserEmail() async {
    userEmail = await SharedPreferencesController.getUserEmail();
    setState(() {});
  }

  Future<void> _deleteAnexo(int index) async {
    final String? error = await excluirFotoAnexo(
      email: userEmail!,
      password: userPassword!,
      chamadoId: widget.chamado['id'].toString(),
      chamadoAnexoId: anexos![index]['id'].toString(),
    );

    if (error == null) {
      setState(() {
        anexos!.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  String _getPhotoUrl(String photoPath) {
    return '${ConstsApi.baseUrl}$photoPath';
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chamado',
              style: TextStyle(
                fontSize: 24,
                color: darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'Checkin ${widget.chamado['checkInId']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  ' / NF ${widget.chamado['nfCompraId']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
            Text(
              '${widget.chamado['produtoDesc']}',
              style: TextStyle(
                fontSize: 20,
                color: darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.chamado['statusDesc']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Tipo: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.chamado['chamadoTipoDesc']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Observação: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('${widget.chamado['observacao']}'),
            const SizedBox(height: 20),
            const Text(
              'Fotos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (anexos != null && anexos!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: anexos!.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.network(
                            _getPhotoUrl(anexos![index]['foto']),
                            fit: BoxFit.cover,
                            height: 200,
                            width: 200,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAnexo(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            else
              const Text('Nenhuma foto anexada.'),
          ],
        ),
      ),
    );
  }
}
