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

  // Función para mostrar formulario
  void _mostrarFormulario() {
    String titulo = "";
    int nota = 0;
    DateTime? fechaSeleccionada;
    String estado = "Pendiente";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Agregar nueva evaluación"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Campo Título
                    TextField(
                      decoration: const InputDecoration(labelText: "Título"),
                      onChanged: (value) => titulo = value,
                    ),

                    // Campo Nota
                    TextField(
                      decoration: const InputDecoration(labelText: "Nota"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => nota = int.tryParse(value) ?? 0,
                    ),

                    const SizedBox(height: 16),

                    // Selector de Fecha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fechaSeleccionada == null
                              ? "Sin fecha"
                              : "Fecha: ${fechaSeleccionada.toString().substring(0, 10)}",
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setStateDialog(() {
                                fechaSeleccionada = pickedDate;
                              });
                            }
                          },
                          child: const Text("Seleccionar fecha"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titulo.isNotEmpty && fechaSeleccionada != null) {
                      setState(() {
                        evaluaciones.add({
                          "titulo": titulo,
                          "fecha": fechaSeleccionada,
                          "nota": nota,
                          "estado": estado,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Agregar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Función para obtener color según el estado
  Color colorEstado(String estado) {
    switch (estado) {
      case "Completada":
        return const Color.fromARGB(255, 4, 252, 12);
      case "Vencida":
        return const Color.fromARGB(255, 247, 19, 2);
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
        backgroundColor: const Color.fromARGB(255, 93, 2, 250),
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
            color: colorEstado(eval["estado"]).withOpacity(0.3),
            child: ListTile(
              title: Text(eval["titulo"]),
              subtitle: Text(
                "Fecha: ${eval["fecha"].toLocal().toString().split(' ')[0]} - Nota: ${eval["nota"]}",
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    eval["estado"],
                    style: TextStyle(color: colorEstado(eval["estado"])),
                  ),
                  IconButton(
                    icon: const Icon(Icons.highlight_remove, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        evaluaciones.removeAt(index); // 👈 elimina la tarea
                      });
                    },
                  ),
                ],
              ),
              onTap: () => actualizarEstado(index),
            ),
          );
        },
      ), // 👈 aquí cierro bien el ListView.builder
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 93, 2, 250), // morado
        foregroundColor: Colors.white, // ícono blanco
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
                      ? const Color.fromARGB(255, 229, 235, 230)
                      : eval["estado"] == "Vencida"
                      ? const Color.fromARGB(255, 245, 241, 241)
                      : const Color.fromARGB(255, 243, 243, 241),
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
                      ? const Color.fromARGB(255, 4, 253, 12)
                      : eval["estado"] == "Vencida"
                      ? const Color.fromARGB(255, 247, 17, 1)
                      : const Color.fromARGB(255, 217, 255, 2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
