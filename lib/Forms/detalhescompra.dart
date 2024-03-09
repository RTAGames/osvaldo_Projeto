import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_loja/Classes/compra.dart';

class DetalhesCompraF extends StatefulWidget {
  final Compra compra;

  const DetalhesCompraF({super.key, required this.compra});

  @override
  // ignore: library_private_types_in_public_api
  _DetalhesCompraF createState() => _DetalhesCompraF();
}

class _DetalhesCompraF extends  State<DetalhesCompraF>{
  Compra compraObj = Compra(
    id: '',
    loja: '',
    data: DateTime.now(),
    produtos: [],
    userid: '',
  );

  @override
  void initState(){
    super.initState();
    compraObj = widget.compra;
    _updateCompra();
  }

  Future<void> _updateCompra() async{
    FirebaseFirestore.instance.collection('compras').doc(widget.compra.id).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        setState(() {
          compraObj = Compra.fromMap(documentSnapshot.data());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Compra'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _updateCompra(),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loja: ${widget.compra.loja}'),
              Text('Data ${widget.compra.data.toString().substring(0, 10)}'),
              const SizedBox(height: 15),
              const Text('Produtos:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.compra.produtos.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(widget.compra.produtos[index].nome),
                    subtitle: Text('Preço: €${widget.compra.produtos[index].preco}'),
                    trailing: Text('Quantidade: ${widget.compra.produtos[index].quantidade}'),
                  );
                },
              ),
              Text(
                'Preço Total: €${widget.compra.produtos.fold(0.0, (previousValue, element) => previousValue + element.preco * element.quantidade).toString()}',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                    FirebaseFirestore.instance.collection('compras').where('id', isEqualTo: widget.compra.id).get().then((QuerySnapshot querySnapshot){
                      querySnapshot.docs.first.reference.delete();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra Eliminada')));
                    Navigator.of(context).pop();
                  }, child: const Text('Eliminar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}