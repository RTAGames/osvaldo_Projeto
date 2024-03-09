import 'package:flutter/material.dart';
import 'package:projeto_loja/Classes/produto.dart';

class ProdutoItem extends StatelessWidget{
  final Produto produto;
  final VoidCallback onUpdate;
  final VoidCallback onRemove;

  const ProdutoItem({super.key, required this.produto, required this.onUpdate, required this.onRemove});

  @override
  Widget build(BuildContext context){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(decoration: const InputDecoration(
              labelText: 'Nome do Produto',
            ),
              onChanged: (value){
              produto.nome=value;
              onUpdate();
              },
            ),
            const SizedBox(height: 8),
            TextField(decoration: const InputDecoration(
              labelText: 'Quantidade',
            ),
            onChanged: (value)
              {
                produto.quantidade = int.parse(value);
                onUpdate();
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Preço',
              ),
              onChanged: (value) {
                produto.preco = double.parse(value);
                onUpdate();
              },
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
            ),
            ElevatedButton(onPressed: onRemove, child: const Text('Eliminar'),),
          ],
        ),
      ),
    );
  }
}