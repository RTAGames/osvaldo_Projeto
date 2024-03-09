import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_loja/firebase_options.dart';
import 'package:projeto_loja/Forms/login.dart';
import 'package:projeto_loja/Forms/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja do Indiano',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/Setsuna_bread.png')
              ),
              SizedBox(height: 20),
              Text('Temos Kebab',
                style: TextStyle(fontSize: 20),
              ),
              Text('Desconto estudante na compra de 3 ou mais menus',
                style: TextStyle(fontSize: 14)),
              SizedBox(height: 20),
              Buttons(),
            ],
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatefulWidget{
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _Buttons();
}

class _Buttons extends State<Buttons> {
  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()),);
        },
        child: const Text('Login'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()),);
        },
        child: const Text('Registo'),)
      ],
    );
  }
}
