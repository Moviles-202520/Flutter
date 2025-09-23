import 'package:flutter/material.dart';

class ConfirmLogoutView extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const ConfirmLogoutView({Key? key, required this.onYes, required this.onNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // Fondo semitransparente para foco modal
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Está seguro que quiere cerrar sesión?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onYes,
                    child: const Text('Sí'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(100, 40),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: onNo,
                    child: const Text('No'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}