import 'package:flutter/material.dart';
import 'login.dart';

// 🎨 Paleta de colores profesional
const Color colorPrimario = Color(0xFF5D02FA);
const Color colorAprobada = Color(0xFF43A047);
const Color colorReprobada = Color(0xFFE53935);
const Color colorVencida = Color(0xFFF57C00);
const Color colorPendiente = Color(0xFFFFC107);

class EvaluacionesPage extends StatefulWidget {
  const EvaluacionesPage({super.key});

  @override
  State<EvaluacionesPage> createState() => _EvaluacionesPageState();
}

class _EvaluacionesPageState extends State<EvaluacionesPage> {
  List<Map<String, dynamic>> evaluaciones = [
    {
      "titulo": "Matemáticas - Álgebra",
      "fecha": DateTime(2025, 10, 26),
      "nota": 70,
      "nota necesaria": 40,
      "estado": "Pendiente",
    },
    {
      "titulo": "Lenguaje - Redacción",
      "fecha": DateTime(2025, 9, 27),
      "nota": 45,
      "nota necesaria": 50,
      "estado": "Pendiente",
    },
    {
      "titulo": "Historia - Edad Media",
      "fecha": DateTime(2025, 10, 28),
      "nota": 70,
      "nota necesaria": 60,
      "estado": "Pendiente",
    },
  ];

  // 🎨 Función para determinar color según estado
  Color colorEstado(String estado) {
    switch (estado) {
      case "Aprobada":
        return colorAprobada;
      case "Reprobada":
        return colorReprobada;
      case "Vencida":
        return colorVencida;
      default:
        return colorPendiente;
    }
  }

  // 🔁 Cambia automáticamente estado
  void actualizarEstado(int index) {
    setState(() {
      var eval = evaluaciones[index];
      DateTime hoy = DateTime.now();

      if (eval["fecha"].isBefore(hoy) && eval["estado"] == "Pendiente") {
        eval["estado"] = "Vencida";
      } else if (eval["nota"] >= eval["nota necesaria"]) {
        eval["estado"] = "Aprobada";
      } else {
        eval["estado"] = "Reprobada";
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Estado actualizado a: ${evaluaciones[index]["estado"]}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: colorEstado(evaluaciones[index]["estado"]),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void resetearEstado(int index) {
    setState(() {
      evaluaciones[index]["estado"] = "Pendiente";
    });
  }

  // 🧾 Formulario para nueva evaluación
  void _mostrarFormulario() {
    String titulo = "";
    int nota = 0;
    int notaNecesaria = 0;
    DateTime? fechaSeleccionada;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Agregar nueva evaluación"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: "Título"),
                    onChanged: (v) => titulo = v,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: "Nota obtenida"),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => nota = int.tryParse(v) ?? 0,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: "Nota necesaria para aprobar"),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => notaNecesaria = int.tryParse(v) ?? 0,
                  ),
                  const SizedBox(height: 12),
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
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setStateDialog(() => fechaSeleccionada = picked);
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
                  if (titulo.isEmpty || fechaSeleccionada == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Completa todos los campos antes de continuar"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  setState(() {
                    evaluaciones.add({
                      "titulo": titulo,
                      "fecha": fechaSeleccionada,
                      "nota": nota,
                      "nota necesaria": notaNecesaria,
                      "estado": "Pendiente",
                    });
                  });

                  Navigator.pop(context);
                },
                child: const Text("Agregar"),
              ),
            ],
          );
        });
      },
    );
  }

  // 🔍 Función para buscar evaluaciones
  void _buscarEvaluacion() {
    showSearch(
      context: context,
      delegate: BusquedaEvaluacionDelegate(evaluaciones),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Evaluaciones"),
        backgroundColor: colorPrimario,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: "Buscar evaluación",
            onPressed: _buscarEvaluacion,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: evaluaciones.isEmpty
          ? const Center(
              child: Text("No hay evaluaciones registradas."),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: evaluaciones.length,
              itemBuilder: (context, index) {
                var eval = evaluaciones[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        eval["estado"] == "Aprobada"
                            ? Icons.check_circle
                            : eval["estado"] == "Reprobada"
                                ? Icons.cancel
                                : eval["estado"] == "Vencida"
                                    ? Icons.error
                                    : Icons.pending,
                        color: colorEstado(eval["estado"]),
                        size: 30,
                      ),
                      title: Text(
                        eval["titulo"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Fecha: ${eval["fecha"].toString().substring(0, 10)}\n"
                        "Nota: ${eval["nota"]} / ${eval["nota necesaria"]}",
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            eval["estado"] = value;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Marcado como $value"),
                              backgroundColor: colorEstado(value),
                            ),
                          );
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: "Pendiente", child: Text("Pendiente")),
                          const PopupMenuItem(
                              value: "Aprobada", child: Text("Aprobada")),
                          const PopupMenuItem(
                              value: "Reprobada", child: Text("Reprobada")),
                          const PopupMenuItem(
                              value: "Vencida", child: Text("Vencida")),
                        ],
                      ),
                      onTap: () => actualizarEstado(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarFormulario,
        label: const Text(
          "Nueva evaluación",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_task, color: Colors.white),
        backgroundColor: colorPrimario,
      ),
    );
  }
}

// 🔍 Buscador personalizado
class BusquedaEvaluacionDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> evaluaciones;
  BusquedaEvaluacionDelegate(this.evaluaciones);

  @override
  String get searchFieldLabel => "Buscar evaluación...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultados = evaluaciones
        .where((e) =>
            e["titulo"].toLowerCase().contains(query.toLowerCase().trim()))
        .toList();

    if (resultados.isEmpty) {
      return const Center(
        child: Text("No se encontraron coincidencias"),
      );
    }

    return ListView(
      children: resultados.map((eval) {
        return ListTile(
          leading: Icon(Icons.assignment,
              color: colorPrimario.withOpacity(0.7)),
          title: Text(eval["titulo"]),
          subtitle: Text(
              "Fecha: ${eval["fecha"].toString().substring(0, 10)} - Estado: ${eval["estado"]}"),
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        "Escribe para buscar evaluaciones...",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
