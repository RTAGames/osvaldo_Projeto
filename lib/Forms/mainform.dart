import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_loja/Classes/compra.dart';
import 'package:projeto_loja/Componente/compraexe.dart';
import 'package:projeto_loja/main.dart';
import 'package:projeto_loja/Forms/carrinho.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage>{
  final List<Compra> _compras = [];

  @override
  void initState() {super.initState(); _loadCompras();}

  void _loadCompras(){
    User sessao = FirebaseAuth.instance.currentUser as User;
    
    FirebaseFirestore.instance.collection('compras').where('userid', isEqualTo: sessao.uid).get().then((QuerySnapshot querySnapshot){
      for (var doc in querySnapshot.docs){
        setState(() {
          _compras.add(Compra.fromMap(doc.data()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja do Indiano'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(decoration: BoxDecoration(color: Colors.deepPurpleAccent, image: DecorationImage(image: AssetImage('images/osvaldokebabs.png'), fit: BoxFit.fill)),
            child: Text('Loja do Indiano', style: TextStyle(color: Colors.white, fontSize: 20, backgroundColor: Color.fromARGB(50, 0, 0, 0)), textAlign: TextAlign.center,)),
            ListTile(
              title: const Text('Encerrar Sessão'),
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp(),),);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(
          const Duration(seconds: 1),
            (){
            setState(() {
              _compras.clear();
              _loadCompras();
              });
            },
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('O seu histórico de compras'),
              const SizedBox(height: 20),
              Expanded(child: ListView.builder(itemCount: _compras.length, itemBuilder: (context, index){
                return Compraexe(compra: _compras[index]);
              },),)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdicionarCompra()),);
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Image(image: AssetImage('images/Fw7eBPAakAA7QZx.jpg'),
          width: 25,
          height: 25),
      ),
    );
  }
}