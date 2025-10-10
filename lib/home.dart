import 'package:flutter/material.dart';
import 'login.dart';

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
      "nota necesaria": 40,
      "estado": "Pendiente",
    },
    {
      "titulo": "Lenguaje - Redacción",
      "fecha": DateTime(2025, 9, 27, 00, 00),
      "nota": 45,
      "nota necesaria": 50,
      "estado": "Pendiente",
    },
    {
      "titulo": "Historia - Edad Media",
      "fecha": DateTime(2025, 10, 28, 00, 00),
      "nota": 70,
      "nota necesaria": 60,
      "estado": "Pendiente",
    },
  ];
  // Función para actualizar el estado según la fecha o el usuario
  void actualizarEstado(int index) {
    setState(() {
      DateTime hoy = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      var eval = evaluaciones[index];
      DateTime fechaEval = eval["fecha"];
      int nota = eval["nota"] ?? 0;
      int notaNecesaria = eval["nota necesaria"] ?? 0;

      // Si la evaluación ya venció y no se completó
      if (eval["estado"] != "Aprobada" &&
          eval["estado"] != "Reprobada" &&
          fechaEval.isBefore(hoy)) {
        eval["estado"] = "Vencida";
      }
      // Si la evaluación estaba pendiente o vencida, evaluar según la nota
      else if (eval["estado"] == "Pendiente" || eval["estado"] == "Vencida") {
        if (nota >= notaNecesaria) {
          eval["estado"] = "Aprobada";
        } else {
          eval["estado"] = "Reprobada";
        }
      }
      // Si ya está Aprobada o Reprobada, no cambia automáticamente
    });
  }

  // Función para resetear una evaluación a Pendiente
  void resetearEstado(int index) {
    setState(() {
      evaluaciones[index]["estado"] = "Pendiente";
    });
  }

  // Función para mostrar formulario
  void _mostrarFormulario() {
    String titulo = "";
    int nota = 0;
    int notaNecesaria = 0;
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
                      decoration: const InputDecoration(labelText: "Nota obtenida"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => nota = int.tryParse(value) ?? 0,
                    ),

                    // Campo Nota Necesaria
                    TextField(
                      decoration: const InputDecoration(labelText: "Nota necesaria para aprobar"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => notaNecesaria = int.tryParse(value) ?? 0,
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
                          "nota necesaria": notaNecesaria,
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
      case "Aprobada":
        return const Color.fromARGB(253, 45, 252, 4); // verde
      case "Reprobada":
        return const Color.fromARGB(255, 200, 0, 0); // rojo
      case "Vencida":
        return const Color.fromARGB(255, 141, 0, 0); // rojo oscuro
      case "Pendiente":
      default:
        return const Color.fromARGB(255, 175, 149, 0); // amarillo
    }
  }

  String barrabusqueda = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mis Evaluaciones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF5D02FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: "Buscar evaluación",
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(
                  evaluaciones,
                  onActualizar: (index) => actualizarEstado(index),
                  onResetear: (index) => resetearEstado(index),
                  onRefresh: () => setState(() {}),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Cerrar sesión"),
                  content: const Text(
                    "¿Estás seguro que deseas cerrar sesión?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text("Cerrar sesión"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: evaluaciones.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No hay evaluaciones",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Agrega una nueva evaluación con el botón +",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: evaluaciones.length,
              itemBuilder: (context, index) {
                var eval = evaluaciones[index];
                // Verificar si la evaluación venció (solo si no está Aprobada ni Reprobada)
                if (eval["estado"] != "Aprobada" &&
                    eval["estado"] != "Reprobada" &&
                    eval["fecha"].isBefore(DateTime.now())) {
                  eval["estado"] = "Vencida";
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorEstado(eval["estado"]).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => actualizarEstado(index),
                    onLongPress: () {
                      // Mostrar diálogo para confirmar reseteo
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Resetear evaluación"),
                          content: Text(
                            "¿Deseas cambiar '${eval["titulo"]}' a Pendiente?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancelar"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5D02FA),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                resetearEstado(index);
                                Navigator.pop(context);
                              },
                              child: const Text("Resetear"),
                            ),
                          ],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colorEstado(eval["estado"]).withOpacity(0.1),
                            colorEstado(eval["estado"]).withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icono indicador de estado
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorEstado(
                                  eval["estado"],
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                eval["estado"] == "Aprobada"
                                    ? Icons.check_circle
                                    : eval["estado"] == "Reprobada"
                                    ? Icons.cancel
                                    : eval["estado"] == "Vencida"
                                    ? Icons.error
                                    : Icons.pending,
                                color: colorEstado(eval["estado"]),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Información de la evaluación
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eval["titulo"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3C096C),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        eval["fecha"]
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.grade,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Nota: ${eval["nota"]}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorEstado(eval["estado"]),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      eval["estado"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Botón eliminar
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              tooltip: "Eliminar",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Eliminar evaluación"),
                                    content: Text(
                                      "¿Deseas eliminar '${eval["titulo"]}'?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancelar"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            evaluaciones.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Eliminar"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarFormulario,
        icon: const Icon(Icons.add),
        label: const Text("Nueva"),
        backgroundColor: const Color(0xFF5D02FA),
        foregroundColor: Colors.white,
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> evaluaciones;
  final Function(int) onActualizar;
  final Function(int) onResetear;
  final Function() onRefresh;

  MySearchDelegate(
    this.evaluaciones, {
    required this.onActualizar,
    required this.onResetear,
    required this.onRefresh,
  });

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

  Color _getColorEstado(String estado) {
    switch (estado) {
      case "Aprobada":
        return const Color.fromARGB(253, 45, 252, 4); // verde
      case "Reprobada":
        return const Color.fromARGB(255, 200, 0, 0); // rojo
      case "Vencida":
        return const Color.fromARGB(255, 141, 0, 0); // rojo oscuro
      case "Pendiente":
      default:
        return const Color.fromARGB(255, 175, 149, 0); // amarillo
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = evaluaciones
        .asMap()
        .entries
        .where((entry) => entry.value["titulo"]
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No se encontraron resultados",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final entry = results[index];
            final evalIndex = entry.key;
            final eval = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _getColorEstado(eval["estado"]).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                  onActualizar(evalIndex);
                  onRefresh();
                  setState(() {});
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Resetear evaluación"),
                      content: Text(
                        "¿Deseas cambiar '${eval["titulo"]}' a Pendiente?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5D02FA),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            onResetear(evalIndex);
                            onRefresh();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text("Resetear"),
                        ),
                      ],
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        _getColorEstado(eval["estado"]).withOpacity(0.1),
                        _getColorEstado(eval["estado"]).withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icono indicador
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getColorEstado(eval["estado"])
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            eval["estado"] == "Aprobada"
                                ? Icons.check_circle
                                : eval["estado"] == "Reprobada"
                                    ? Icons.cancel
                                    : eval["estado"] == "Vencida"
                                        ? Icons.error
                                        : Icons.pending,
                            color: _getColorEstado(eval["estado"]),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Información
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eval["titulo"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3C096C),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    eval["fecha"]
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.grade,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${eval["nota"]}/${eval["nota necesaria"]}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getColorEstado(eval["estado"]),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  eval["estado"],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Indicador de interacción
                        Icon(
                          Icons.touch_app,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "Busca tus evaluaciones",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Escribe el nombre de la evaluación",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    final suggestions = evaluaciones
        .asMap()
        .entries
        .where((entry) => entry.value["titulo"]
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No hay coincidencias",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final entry = suggestions[index];
            final evalIndex = entry.key;
            final eval = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _getColorEstado(eval["estado"]).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                  onActualizar(evalIndex);
                  onRefresh();
                  setState(() {});
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Resetear evaluación"),
                      content: Text(
                        "¿Deseas cambiar '${eval["titulo"]}' a Pendiente?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5D02FA),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            onResetear(evalIndex);
                            onRefresh();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text("Resetear"),
                        ),
                      ],
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Icono con badge de estado
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getColorEstado(eval["estado"])
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              eval["estado"] == "Aprobada"
                                  ? Icons.check_circle
                                  : eval["estado"] == "Reprobada"
                                      ? Icons.cancel
                                      : eval["estado"] == "Vencida"
                                          ? Icons.error
                                          : Icons.pending,
                              color: _getColorEstado(eval["estado"]),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // Información expandida
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eval["titulo"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF3C096C),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  eval["fecha"]
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.grade,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${eval["nota"]}/${eval["nota necesaria"]}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Badge de estado
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getColorEstado(eval["estado"]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          eval["estado"],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
