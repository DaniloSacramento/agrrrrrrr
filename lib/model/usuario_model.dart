// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:trivia_checkin/model/loja_model.dart';

class UsuarioModel {
  final int id;
  final String nome;
  final String email;
  List<LojaModel> lojas;
  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.lojas,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'lojas': lojas.map((x) => x.toMap()).toList(),
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] as int,
      nome: map['nome'] as String,
      email: map['email'] as String,
      lojas: map['lojas'] != null
          ? List<LojaModel>.from(
              (map['lojas'] as List).map<LojaModel>(
                (x) => LojaModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) =>
      UsuarioModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nome: $nome, email: $email, lojas: $lojas)';
  }

  @override
  bool operator ==(covariant UsuarioModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.nome == nome &&
        other.email == email &&
        listEquals(other.lojas, lojas);
  }

  @override
  int get hashCode {
    return id.hashCode ^ nome.hashCode ^ email.hashCode ^ lojas.hashCode;
  }
}
