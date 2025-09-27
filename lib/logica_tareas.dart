import 'package:flutter/material.dart';

class EvaluacionesPage extends StatefulWidget {
  const EvaluacionesPage({super.key});

  @override
  State<EvaluacionesPage> createState() => _EvaluacionesPageState();
}

class _EvaluacionesPageState extends State<EvaluacionesPage> {
  // Lista de evaluaciones
  List<Map<String, dynamic>> evaluaciones = [
    {
      "titulo": "Matemáticas - Álgebra",
      "fecha": DateTime(2025, 9, 26),
      "nota": 70,
      "estado": "Pendiente",
    },
    {
      "titulo": "Lenguaje - Redacción",
      "fecha": DateTime(2025, 9, 27),
      "nota": 85,
      "estado": "Pendiente",
    },
    {
      "titulo": "Historia - Edad Media",
      "fecha": DateTime(2025, 9, 28),
      "nota": 90,
      "estado": "Pendiente",
    },
  ];

  // Función para actualizar el estado según la fecha o el usuario
  void actualizarEstado(int index) {
    setState(() {
      DateTime hoy = DateTime.now();
      var eval = evaluaciones[index];

      if (eval["estado"] != "Completada" && eval["fecha"].isBefore(hoy)) {
        eval["estado"] = "Vencida";
      } else if (eval["estado"] == "Pendiente") {
        eval["estado"] = "Completada";
      } else if (eval["estado"] == "Completada") {
        eval["estado"] = "Pendiente";
      }
    });
  }

  // Función para obtener color según el estado
  Color colorEstado(String estado) {
    switch (estado) {
      case "Completada":
        return Colors.green;
      case "Vencida":
        return Colors.red;
      case "Pendiente":
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Evaluaciones")),
      body: ListView.builder(
        itemCount: evaluaciones.length,
        itemBuilder: (context, index) {
          var eval = evaluaciones[index];
          return Card(
            margin: const EdgeInsets.all(8),
            color: colorEstado(eval["estado"]).withOpacity(0.2),
            child: ListTile(
              title: Text(eval["titulo"]),
              subtitle: Text(
                "Fecha: ${eval["fecha"].day}/${eval["fecha"].month}/${eval["fecha"].year} - Nota: ${eval["nota"]} - Estado: ${eval["estado"]}",
              ),
              trailing: IconButton(
                icon: Icon(
                  eval["estado"] == "Completada"
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: colorEstado(eval["estado"]),
                ),
                onPressed: () => actualizarEstado(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
