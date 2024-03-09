import 'package:flutter/material.dart';
import 'package:projeto_loja/Classes/compra.dart';
import 'package:projeto_loja/Forms/detalhescompra.dart';

class Compraexe extends StatelessWidget{
  final Compra compra;

  const Compraexe({super.key,  required this.compra});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetalhesCompraF(compra: compra),),)
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Loja: ${compra.loja}'),
            Text('Data: ${compra.data.toString().substring(0,10)}'),
            Text('Preço Total: €${compra.produtos.fold(0.0, (previousValue, element) => previousValue + element.preco * element.quantidade).toString()}')
          ],
        ),
      ),
    );
  }
}