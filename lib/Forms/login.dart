import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_loja/Forms/mainform.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Login createState() => _Login();
}

class _Login extends State<Login>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja do Indiano - Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage('images/IMG_2582.png'), height: 400, width: 400,fit: BoxFit.fill,
            ),
            TextField(
              controller: _emailC,
              decoration: const InputDecoration(
                labelText: 'Introduza o email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passC,
              decoration: const InputDecoration(
                labelText: 'Introduza a palavra-passe',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {
              _login();
            },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _login() async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailC.text, password: _passC.text);
      
      if (userCredential.user != null){
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context){
            return const MainPage();
          },),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('A grelha está a aquecer'),));
      }
    } catch (e){
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
    }
  }
}