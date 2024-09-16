import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:trivia_checkin/controller/shared_preference_controller.dart';
import 'package:trivia_checkin/navigation_menu.dart';
import 'package:trivia_checkin/services/chamado_service.dart';
import 'package:trivia_checkin/services/chamado_tipos_service.dart';
import 'package:trivia_checkin/services/foto_servoce.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';
import 'package:trivia_checkin/widgets/tringulo_pointer_widgets.dart';

class ChamadoPageItem extends StatefulWidget {
  final dynamic item;
  const ChamadoPageItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ChamadoPageItem> createState() => _ChamadoPageItemState();
}

class _ChamadoPageItemState extends State<ChamadoPageItem> {
  String? userPassword;
  final _observacaoController = TextEditingController();
  String? userEmail;
  Uint8List? imageBytes;
  List<dynamic> chamados = [];
  List<Uint8List> uploadedImages = [];
  String? selectedChamado;
  int? selectedChamadoId;
  int? qtdAnexos;
  int? checkInId;
  int? _removingImageIndex;
  int? nfCompraId;
  int? produtoId;
  int _charCount = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _initializeUserDetails();
    print(widget.item);
  }

  Future<void> _initializeUserDetails() async {
    await Future.wait([_getUserPassword(), _getUserEmail()]);
    _fetchChamados();

    if (widget.item != null) {
      checkInId = widget.item['notas'][0]['checkInId'];
      if (widget.item['notas'] != null && widget.item['notas'].isNotEmpty) {
        nfCompraId = widget.item['notas'][0]['id'];
        if (widget.item['notas'][0]['itens'] != null &&
            widget.item['notas'][0]['itens'].isNotEmpty) {
          produtoId = widget.item['notas'][0]['itens'][0]['produtoId'];
        }
      }

      setState(() {});
    }
  }

  Future<void> _getUserPassword() async {
    userPassword = await SharedPreferencesController.getUserPassword();
    setState(() {});
  }

  Future<void> _getUserEmail() async {
    userEmail = await SharedPreferencesController.getUserEmail();
    setState(() {});
  }

  Future<void> _fetchChamados() async {
    if (userEmail != null && userPassword != null) {
      try {
        chamados = await chamadoTiposService(
          email: userEmail!,
          password: userPassword!,
        );
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  bool get _isFormValid {
    return _formKey.currentState?.validate() ??
        false && selectedChamado != null && uploadedImages.isNotEmpty;
  }

  void _onChamadoSelected(String? newValue) {
    setState(() {
      selectedChamado = newValue;
      final selectedChamadoItem =
          chamados.firstWhere((chamado) => chamado['descricao'] == newValue);
      selectedChamadoId = selectedChamadoItem['id'];
      qtdAnexos = selectedChamadoItem['qtdAnexos'];
    });
  }

  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;

  Future<void> pick(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        final File imageFile = File(image.path);

        if (await imageFile.exists()) {
          final Uint8List? compressedImageBytes =
              await compressImage(imageFile);

          if (compressedImageBytes != null) {
            setState(() {
              uploadedImages.add(compressedImageBytes);
            });
          } else {
            // Handle compression failure
            setState(() async {
              uploadedImages.add(await imageFile.readAsBytes());
            });
          }
        }
      }
    } catch (e) {
      print('Error selecting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image.')),
      );
    }
  }

  Future<Uint8List?> compressImage(File file) async {
    try {
      return await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 85,
      );
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
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
          padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
          child: Builder(builder: (context) {
            print(selectedChamadoId);
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
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
                          'Checkin: ${item['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(' / '),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    if (item != null) ...[
                      Text(
                        '${item['notas'][0]['itens'][0]['produtoId']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          '${item['notas'][0]['itens'][0]['produtoDesc']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkBlueColor,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      if (chamados.isNotEmpty) ...[
                        const Text(
                          'Selecione um tipo de chamado',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 0, right: 0, top: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: darkBlueColor),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedChamado,
                                isExpanded: true,
                                iconSize: 24,
                                style: TextStyle(
                                  color: darkBlueColor,
                                  fontSize: 16,
                                ),
                                dropdownColor: Colors.white,
                                items: chamados
                                    .map<DropdownMenuItem<String>>((chamado) {
                                  return DropdownMenuItem<String>(
                                    value: chamado['descricao'],
                                    child: Text(chamado['descricao']),
                                  );
                                }).toList(),
                                onChanged: _onChamadoSelected,
                              ),
                            ),
                          ),
                        )
                      ],
                      const SizedBox(height: 16),
                      const Text(
                        'Observação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _observacaoController,
                        maxLength: 600, // Define o limite de caracteres
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          counterText: '$_charCount/600', // Exibe o contador
                        ),
                        onChanged: (value) {
                          setState(() {
                            _charCount = value
                                .length; // Atualiza o contador quando o texto muda
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma observação.';
                          } else if (value.length > 600) {
                            return 'A observação não pode ter mais de 600 caracteres.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    const Text(
                      'Fotos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (qtdAnexos != null && qtdAnexos! > 0) ...[
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: qtdAnexos!,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 4.0),
                                  width: 80,
                                  height: 80,
                                  child: uploadedImages.length > index
                                      ? Stack(
                                          children: [
                                            Image.memory(uploadedImages[index],
                                                fit: BoxFit.cover),
                                            if (_removingImageIndex == index)
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          ],
                                        )
                                      : Container(
                                          color: Colors.grey,
                                          child: const Icon(Icons.photo,
                                              color: Colors.white),
                                        ),
                                ),
                                if (uploadedImages.length > index &&
                                    _removingImageIndex != index)
                                  Positioned(
                                    top: -5,
                                    right: -5,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        setState(() {
                                          _removingImageIndex = index;
                                        });
                                        try {
                                          // Simule uma operação de exclusão
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          setState(() {
                                            uploadedImages.removeAt(index);
                                          });
                                        } catch (e) {
                                          print('Erro ao excluir a foto: $e');
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Erro ao excluir a foto.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } finally {
                                          setState(() {
                                            _removingImageIndex = null;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.blueAccent,
                            onPressed: () {
                              _showOpcoesBottomSheet();
                            },
                            child: const Icon(Icons.camera_alt),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${uploadedImages.length}/$qtdAnexos',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isFormValid)
            FloatingActionButton(
              onPressed: () async {
                if (selectedChamado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, selecione um tipo de chamado.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (uploadedImages.length < (qtdAnexos ?? 0)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Você precisa enviar ${qtdAnexos ?? 0} fotos.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (_formKey.currentState!.validate()) {
                  chamadoService(
                    email: userEmail!,
                    password: userPassword!,
                    chamadoTipoId: selectedChamadoId!,
                    checkInId: checkInId!,
                    nfCompraId: nfCompraId!,
                    observacao: _observacaoController.text,
                    produtoId: produtoId!,
                  );

                  for (var imageBytes in uploadedImages) {
                    await AlterarFoto().fotoPromotor(
                      chamadoId: selectedChamadoId!,
                      file: imageBytes,
                    );
                  }
                  Navigator.pushAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationMenu(
                        initialHomePage: InitialHomePage.checkins,
                      ),
                    ),
                    (r) => false,
                  );
                }
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
            ),
          const SizedBox(width: 5),
          FloatingActionButton(
            onPressed: () {
              _observacaoController.clear();
              setState(() {
                selectedChamado = null;
              });
              Navigator.pop(context);
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
