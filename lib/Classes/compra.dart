import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_loja/Classes/produto.dart';

class Compra {
  String id;
  String loja;
  DateTime data;
  List<Produto> produtos;
  String userid;

  Compra(
  {
    this.id = '',
    this.loja = '',
    required this.data,
    this.produtos = const [],
    this.userid = ''
  });

  static Compra fromMap(Object? data){
    Map<String, dynamic> dataMap = data as Map<String, dynamic>;

    return Compra(
      id: dataMap['id'] ?? '',
      loja: dataMap['loja'] ?? '',
      data: (dataMap['data'] as Timestamp).toDate(),
      produtos: (dataMap['produtos'] as List<dynamic>).map((item) => Produto.fromMap(item)).toList(),
      userid: dataMap['userid'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'loja': loja,
      'data': data,
      'produtos': produtos.map((e) => e.toMap()).toList(),
      'userid': userid,
    };
  }
}