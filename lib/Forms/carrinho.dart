import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_loja/Classes/produto.dart';
import 'package:projeto_loja/Classes/compra.dart';
import 'package:projeto_loja/Componente/produtoitem.dart';
import 'package:projeto_loja/Componente/guid.dart';

class AdicionarCompra extends StatefulWidget{
  final Compra? compra;

  const AdicionarCompra({super.key, this.compra});

  @override
  // ignore: library_private_types_in_public_api
  _AdicionarCompra createState() => _AdicionarCompra();
}

class _AdicionarCompra extends State<AdicionarCompra>{
  final TextEditingController _lojaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  double _totalPreco = 0;
  final List<Produto> _produtos = [];

  @override
  void initState(){super.initState();
  if(widget.compra != null){
    _lojaController.text=widget.compra!.loja;
    _dateController.text=widget.compra!.data.toString().substring(0,10);
    _produtos.addAll(widget.compra!.produtos);
    }
  }
  
  @override
  void dispose(){
    _lojaController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  
  void _adicionarproduto(){
    setState(() {
      _produtos.add(Produto());
    });
  }

  void _removerproduto(int index){
    setState(() {
      _produtos.removeAt(index);
    });
  }

  void _updateprecototal(){
    double precototal = 0;
    for(Produto produto in _produtos){
      precototal += produto.preco * produto.quantidade;
    }
    setState(() {
      _totalPreco = precototal;
    });
  }

  void _enviardados(){
    User sessao = FirebaseAuth.instance.currentUser as User;

    Compra compra = Compra(
      id: widget.compra != null ? widget.compra!.id :  generateGuid(),
      loja: _lojaController.text,
      data: DateTime.parse(_dateController.text),
      produtos: _produtos,
      userid: sessao.uid,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;

    if(widget.compra != null){
      db.collection('compras').where('id', isEqualTo: widget.compra!.id).get().then((QuerySnapshot querySnapshot){
        for(var doc in querySnapshot.docs){
          db.collection('compras').doc(doc.id).update(compra.toMap());
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra atualizada'),),);
    } else {
      db.collection('compras').add(compra.toMap());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra adicionada'),),);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.compra != null ? 'Editar Compra' : 'Adicionar Compra'),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _lojaController,
                decoration: const InputDecoration(labelText: 'Nome da Loja'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(icon: Icon(Icons.calendar_view_day),
              labelText: 'Data de Compra'),
              readOnly: true,
              onTap: () async{
                DateTime? data = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1990), lastDate: DateTime(2100));
                if (data != null){
                  setState(() {
                    _dateController.text = data.toString().substring(0, 10);
                  });
                } else{
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Escolha a data'),));
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Produtos', style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(itemCount: _produtos.length,
              itemBuilder: (context, index){
                return ProdutoItem(produto: _produtos[index], onUpdate: () => _updateprecototal(), onRemove: () => _removerproduto(index),);
              },),
            ),
            const SizedBox(height: 16),
            Text('Preço Total: €${_totalPreco.toString()}',
            style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _adicionarproduto, child: const Text('Adicionar Produto'),),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _produtos.isNotEmpty ? _enviardados : null,
              child: Text(
                widget.compra != null ? 'Atualizar Compra' : 'Adicionar Compra'
              ),
            ),
          ],
        ),
      ),
    );
  }
}