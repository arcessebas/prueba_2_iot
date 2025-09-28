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
      "fecha": DateTime(2025, 10, 26, 00, 00),
      "nota": 70,
      "estado": "Pendiente",
    },
    {
      "titulo": "Lenguaje - Redacción",
      "fecha": DateTime(2025, 9, 27, 00, 00),
      "nota": 45,
      "estado": "Pendiente",
    },
    {
      "titulo": "Historia - Edad Media",
      "fecha": DateTime(2025, 10, 28, 00, 00),
      "nota": 70,
      "estado": "Pendiente",
    },
  ];
  // Función para actualizar el estado según la fecha o el usuario
  void actualizarEstado(int index) {
    setState(() {
      DateTime hoy = DateTime(
        DateTime.now().day,
        DateTime.now().month,
        DateTime.now().year,
      );
      DateTime fechahoyeval = evaluaciones[index]["fecha"];
      var eval = evaluaciones[index];

      if (eval["estado"] != "Completada" && fechahoyeval.isBefore(hoy)) {
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
        return const Color.fromARGB(255, 213, 248, 11);
    }
  }

  String barrabusqueda = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluaciones"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(evaluaciones),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: evaluaciones.length,
        itemBuilder: (context, index) {
          var eval = evaluaciones[index];
          if (eval["estado"] != "Completada" &&
              eval["fecha"].isBefore(DateTime.now())) {
            eval["estado"] = "Vencida";
          }
          return AnimatedContainer(
            duration: const Duration(seconds: 2),
            color: colorEstado(eval["estado"]).withOpacity(0.1),
            child: ListTile(
              title: Text(eval["titulo"]),
              subtitle: Text(
                "Fecha: ${eval["fecha"].toLocal().toString().split(' ')[0]} - Nota: ${eval["nota"]}",
              ),
              trailing: Text(
                eval["estado"],
                style: TextStyle(color: colorEstado(eval["estado"])),
              ),
              onTap: () => actualizarEstado(index),
            ),
          );
        },
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> evaluaciones;

  MySearchDelegate(this.evaluaciones);
  @override
  String get searchFieldLabel => 'Buscar evaluaciones';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = evaluaciones.where(
      (eval) => eval["titulo"].toLowerCase().contains(query.toLowerCase()),
    );

    return ListView(
      children: results
          .map<ListTile>(
            (eval) => ListTile(
              title: Text(eval["titulo"]),
              subtitle: Text(
                "Fecha: ${eval["fecha"].toLocal().toString().split(' ')[0]} - Nota: ${eval["nota"]}",
              ),
              trailing: Text(
                eval["estado"],
                style: TextStyle(
                  color: eval["estado"] == "Completada"
                      ? Colors.green
                      : eval["estado"] == "Vencida"
                      ? Colors.red
                      : const Color.fromARGB(255, 213, 248, 11),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = evaluaciones.where(
      (eval) => eval["titulo"].toLowerCase().contains(query.toLowerCase()),
    );

    return ListView(
      children: suggestions
          .map<ListTile>(
            (eval) => ListTile(
              title: Text(eval["titulo"]),
              subtitle: Text(
                "Fecha: ${eval["fecha"].toLocal().toString().split(' ')[0]} - Nota: ${eval["nota"]}",
              ),
              trailing: Text(
                eval["estado"],
                style: TextStyle(
                  color: eval["estado"] == "Completada"
                      ? Colors.green
                      : eval["estado"] == "Vencida"
                      ? Colors.red
                      : const Color.fromARGB(255, 213, 248, 11),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
