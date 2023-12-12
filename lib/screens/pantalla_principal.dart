// screens/pantalla_principal.dart
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/vaso.dart';
import '../models/maquina_cafe.dart';
import '../models/azucarero.dart';

class PantallaPrincipal extends StatefulWidget {
  final Usuario usuario;

  PantallaPrincipal({required this.usuario});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  MaquinaCafe maquinaCafe = MaquinaCafe(
    10,
    Vaso('Pequeño', 20, 0),
    Vaso('Mediano', 15, 0),
    Vaso('Grande', 10, 0),
    Azucarero(20),
  );

  int cantidadAzucarSeleccionada = 0;
  int cantidadCafeSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Máquina de Café'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hola, ${widget.usuario.nombre}!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text('Selecciona el tamaño de vaso:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  botonVaso(maquinaCafe.vasoPequeno),
                  botonVaso(maquinaCafe.vasoMediano),
                  botonVaso(maquinaCafe.vasoGrande),
                ],
              ),
              SizedBox(height: 20),
              Text('Selecciona la cantidad de azúcar:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  botonAzucar(1),
                  botonAzucar(2),
                  botonAzucar(3),
                ],
              ),
              SizedBox(height: 20),
              Text('Selecciona la cantidad de café:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  botonCafe(1),
                  botonCafe(2),
                  botonCafe(3),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: prepararCafe,
                child: Text('Preparar Café'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget botonVaso(Vaso vaso) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          vaso.contenido = 0; // Reiniciar el contenido del vaso al seleccionar un nuevo tamaño
        });
      },
      child: Text('Vaso ${vaso.tamano} - ${vaso.cantidadDisponible} disponibles'),
    );
  }

  Widget botonAzucar(int cantidad) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          cantidadAzucarSeleccionada = cantidad;
        });
      },
      child: Text('$cantidad Cucharadas de Azúcar'),
    );
  }

  Widget botonCafe(int cantidad) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          cantidadCafeSeleccionada = cantidad;
        });
      },
      child: Text('$cantidad Oz de Café'),
    );
  }

  void prepararCafe() {
    if (cantidadAzucarSeleccionada > maquinaCafe.azucarero.stockAzucar) {
      mostrarSnackBar('No hay suficiente azúcar disponible.');
      return;
    }

    if (cantidadCafeSeleccionada <= 0) {
      mostrarSnackBar('Selecciona la cantidad de café.');
      return;
    }

    if (maquinaCafe.vasoPequeno.contenido > 0 ||
        maquinaCafe.vasoMediano.contenido > 0 ||
        maquinaCafe.vasoGrande.contenido > 0) {
      mostrarSnackBar('Ya hay un vaso seleccionado. Completa o descarta el vaso actual.');
      return;
    }

    if (maquinaCafe.vasoPequeno.cantidadDisponible <= 0 &&
        maquinaCafe.vasoMediano.cantidadDisponible <= 0 &&
        maquinaCafe.vasoGrande.cantidadDisponible <= 0) {
      mostrarSnackBar('No hay vasos disponibles.');
      return;
    }

    if (maquinaCafe.stockCafe < cantidadCafeSeleccionada) {
      mostrarSnackBar('No hay suficiente café disponible. Reabastece la máquina.');
      return;
    }

    setState(() {
      // Realizar la preparación del café
      maquinaCafe.stockCafe -= cantidadCafeSeleccionada;
      maquinaCafe.azucarero.stockAzucar -= cantidadAzucarSeleccionada;

      // Seleccionar el vaso y ajustar el contenido
      if (maquinaCafe.vasoPequeno.contenido == 0 && maquinaCafe.vasoPequeno.cantidadDisponible > 0) {
        maquinaCafe.vasoPequeno.contenido = cantidadCafeSeleccionada;
        maquinaCafe.vasoPequeno.cantidadDisponible--;
      } else if (maquinaCafe.vasoMediano.contenido == 0 && maquinaCafe.vasoMediano.cantidadDisponible > 0) {
        maquinaCafe.vasoMediano.contenido = cantidadCafeSeleccionada;
        maquinaCafe.vasoMediano.cantidadDisponible--;
      } else if (maquinaCafe.vasoGrande.contenido == 0 && maquinaCafe.vasoGrande.cantidadDisponible > 0) {
        maquinaCafe.vasoGrande.contenido = cantidadCafeSeleccionada;
        maquinaCafe.vasoGrande.cantidadDisponible--;
      }
    });

    mostrarSnackBar('Café preparado con éxito. ¡Disfruta tu café!');
  }

  void mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
    ));
  }
}
