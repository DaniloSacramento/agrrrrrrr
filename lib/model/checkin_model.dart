// ignore_for_file: public_member_api_docs, sort_constructors_first
class CheckIn {
  final int id;
  final int grupoEmpresarialId;
  final String grupoEmpresarialDesc;
  final int lojaId;
  final String lojaDesc;
  final int fornecedorId;
  final String fornecedorDesc;
  final int motoristaId;
  final String motoristaNome;
  final int veiculoId;
  final String veiculoPlaca;
  final String? dtChegada;
  final String? dtEntrada;
  final String? dtInicio;
  final String? dtTermino;
  final String? dtCancelado;
  final int docaId;
  final String docaDesc;
  final String status;
  final String statusDesc;
  final List<Nota> notas;

  CheckIn({
    required this.id,
    required this.grupoEmpresarialId,
    required this.grupoEmpresarialDesc,
    required this.lojaId,
    required this.lojaDesc,
    required this.fornecedorId,
    required this.fornecedorDesc,
    required this.motoristaId,
    required this.motoristaNome,
    required this.veiculoId,
    required this.veiculoPlaca,
    required this.dtChegada,
    required this.dtEntrada,
    required this.dtInicio,
    required this.dtTermino,
    required this.dtCancelado,
    required this.docaId,
    required this.docaDesc,
    required this.status,
    required this.statusDesc,
    required this.notas,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    var notasList = json['notas'] as List? ?? [];
    List<Nota> notas =
        notasList.map((notaJson) => Nota.fromJson(notaJson)).toList();

    return CheckIn(
      id: json['id'] ?? 0,
      grupoEmpresarialId: json['grupoEmpresarialId'] ?? 0,
      grupoEmpresarialDesc: json['grupoEmpresarialDesc'] ?? '',
      lojaId: json['lojaId'] ?? 0,
      lojaDesc: json['lojaDesc'] ?? '',
      fornecedorId: json['fornecedorId'] ?? 0,
      fornecedorDesc: json['fornecedorDesc'] ?? '',
      motoristaId: json['motoristaId'] ?? 0,
      motoristaNome: json['motoristaNome'] ?? '',
      veiculoId: json['veiculoId'] ?? 0,
      veiculoPlaca: json['veiculoPlaca'] ?? '',
      dtChegada: json['dtChegada'] as String?,
      dtEntrada: json['dtEntrada'] as String?,
      dtInicio: json['dtInicio'] as String?,
      dtTermino: json['dtTermino'] as String?,
      dtCancelado: json['dtCancelado'] as String?,
      docaId: json['docaId'] ?? 0,
      docaDesc: json['docaDesc'] ?? '',
      status: json['status'] ?? '',
      statusDesc: json['statusDesc'] ?? '',
      notas: notas,
    );
  }
}

class Nota {
  int id;
  int checkInId;
  int fornecedorId;
  String fornecedorDesc;
  int? numPedCompra;
  String numNf;
  String serieNf;
  String status;
  String statusDesc;
  String dtEmissao;
  String dtEntrada;
  String dtCadastro;
  double valorTotal;
  List<ItemNota> itens;
  List<Divergencia> divergencias;

  Nota({
    required this.id,
    required this.checkInId,
    required this.fornecedorId,
    required this.fornecedorDesc,
    required this.numPedCompra,
    required this.numNf,
    required this.serieNf,
    required this.status,
    required this.statusDesc,
    required this.dtEmissao,
    required this.dtEntrada,
    required this.dtCadastro,
    required this.valorTotal,
    required this.itens,
    required this.divergencias,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    var itensList = json['itens'] as List;
    List<ItemNota> itens =
        itensList.map((itemJson) => ItemNota.fromJson(itemJson)).toList();

    var divergenciasList = json['divergencias'] as List;
    List<Divergencia> divergencias = divergenciasList
        .map((divergenciaJson) => Divergencia.fromJson(divergenciaJson))
        .toList();

    return Nota(
      id: json['id'],
      checkInId: json['checkInId'],
      fornecedorId: json['fornecedorId'],
      fornecedorDesc: json['fornecedorDesc'],
      numPedCompra: json['numPedCompra'] != null
          ? (json['numPedCompra'] is String
              ? int.tryParse(json['numPedCompra'] ?? '')
              : json['numPedCompra'] as int?)
          : null,
      numNf: json['numNf'],
      serieNf: json['serieNf'],
      status: json['status'],
      statusDesc: json['statusDesc'],
      dtEmissao: json['dtEmissao'],
      dtEntrada: json['dtEntrada'],
      dtCadastro: json['dtCadastro'],
      valorTotal: json['valorTotal'].toDouble(),
      itens: itens,
      divergencias: divergencias,
    );
  }
}

class ItemNota {
  int id;
  int produtoId;
  String produtoDesc;
  int categoriaId;
  String categoriaDesc;
  String unidadeCompra;
  int produtoErpId;
  double qtdCompra;

  ItemNota({
    required this.id,
    required this.produtoId,
    required this.produtoDesc,
    required this.categoriaId,
    required this.categoriaDesc,
    required this.unidadeCompra,
    required this.produtoErpId,
    required this.qtdCompra,
  });

  factory ItemNota.fromJson(Map<String, dynamic> json) {
    return ItemNota(
      id: json['id'],
      produtoId: json['produtoId'],
      produtoDesc: json['produtoDesc'],
      categoriaId: json['categoriaId'],
      categoriaDesc: json['categoriaDesc'],
      unidadeCompra: json['unidadeCompra'],
      qtdCompra: json['qtdCompra'].toDouble(),
      produtoErpId: json['produtoErpId'],
    );
  }
}

class Divergencia {
  int nfCompraId;
  int divergenciaId;
  String divergenciaDesc;
  String divergenciaTipo;
  String divergenciaTipoDesc;
  int userCreateId;
  String userCreateNome;
  String dtCreate;
  String status;
  String statusDesc;
  String observacao;

  Divergencia({
    required this.nfCompraId,
    required this.divergenciaId,
    required this.divergenciaDesc,
    required this.divergenciaTipo,
    required this.divergenciaTipoDesc,
    required this.userCreateId,
    required this.userCreateNome,
    required this.dtCreate,
    required this.status,
    required this.statusDesc,
    required this.observacao,
  });

  factory Divergencia.fromJson(Map<String, dynamic> json) {
    return Divergencia(
      nfCompraId: json['nfCompraId'],
      divergenciaId: json['divergenciaId'],
      divergenciaDesc: json['divergenciaDesc'],
      divergenciaTipo: json['divergenciaTipo'],
      divergenciaTipoDesc: json['divergenciaTipoDesc'],
      userCreateId: json['userCreateId'],
      userCreateNome: json['userCreateNome'],
      dtCreate: json['dtCreate'],
      status: json['status'],
      statusDesc: json['statusDesc'],
      observacao: json['observacao'],
    );
  }
}
