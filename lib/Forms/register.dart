import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_loja/main.dart';

class Register extends StatefulWidget{
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Register createState() => _Register();
}

class _Register extends State<Register>{
  final _key = GlobalKey<FormState>();
  final _usernamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _passworconfirmcontroller = TextEditingController();

  @override
  void dispose(){
    _usernamecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _passworconfirmcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja do Indiano - Registo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage('images/Eso2TwvU4AAjPql.jpg')
              ),
              TextFormField(
                controller: _usernamecontroller,
                decoration: const InputDecoration(labelText: 'Nome de Utilizador'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor insira nome de utilizador';
                  }
                  if (value.length < 3) {
                    return 'Nome de utilizador deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailcontroller,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor introduza um email';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor introduza um email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordcontroller,
                decoration: const InputDecoration(labelText: 'Palavra-passe'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor introduza uma palavra-passe';
                  }
                  if (value.length < 6) {
                    return 'A palavra passe deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passworconfirmcontroller,
                decoration:
                const InputDecoration(labelText: 'Confirmar palavra-passe'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Confirme a palavra-passe';
                  }
                  if (value != _passwordcontroller.text) {
                    return 'As palavras-passe não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    try {
                      final credentials = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailcontroller.text,
                        password: _passwordcontroller.text,
                      );

                      if (credentials.user != null) {
                        await credentials.user!.updateDisplayName(
                          _usernamecontroller.text,
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return const MyApp();
                        },),);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Utilizador Registado'),));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Palavra-passe fraca'),
                          ),
                        );
                      } else if (e.code == 'email-already-in-use') {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'O email já tem conta associada'),
                          ),
                        );
                      }
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}