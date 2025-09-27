import 'package:flutter/material.dart';
import 'logica_tareas.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido $username")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Tus tareas:", style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: EvaluacionesPage(), // ← aquí insertas tu widget de lista
          ),
        ],
      ),
    );
  }
}
