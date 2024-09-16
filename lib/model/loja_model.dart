// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LojaModel {
  final int id;
  final String descricao;

  LojaModel({
    required this.id,
    required this.descricao,
  });

  LojaModel copyWith({
    int? id,
    String? descricao,
  }) {
    return LojaModel(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'descricao': descricao,
    };
  }

  factory LojaModel.fromMap(Map<String, dynamic> map) {
    return LojaModel(
      id: map['id'] as int,
      descricao: map['descricao'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LojaModel.fromJson(String source) =>
      LojaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LojaModel(id: $id, descricao: $descricao)';

  @override
  bool operator ==(covariant LojaModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.descricao == descricao;
  }

  @override
  int get hashCode => id.hashCode ^ descricao.hashCode;
}
