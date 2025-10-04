import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black, // Color del loader
          strokeWidth: 3, // Grosor de la línea
        ),
      ),
    );
  }
}
