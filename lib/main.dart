// main.dart
import 'package:flutter/material.dart';
import 'screens/pantalla_principal.dart';
import 'models/usuario.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Máquina de Café',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaPrincipal(usuario: Usuario(nombre: 'Usuario')),
    );
  }
}
