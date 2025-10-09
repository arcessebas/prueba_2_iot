import 'package:flutter/material.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _login() {
    String email = _userController.text.trim();
    String pass = _passController.text.trim();

    // Validación de campos vacíos
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa correo y contraseña")),
      );
      return;
    }

    // Validación de formato de correo con "@"
    if (!email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El correo debe contener '@'")),
      );
      return;
    }

    // Validación de longitud mínima de contraseña
    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La contraseña debe tener al menos 6 caracteres"),
        ),
      );
      return;
    }

    // Credenciales de prueba
    if (email == "admin@demo.com" && pass == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EvaluacionesPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Correo o contraseña incorrectos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(), // Fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Centra verticalmente
              children: [
                const Icon(Icons.lock, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    labelText: "Correo electrónico",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    labelText: "Contraseña",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("Iniciar Sesión"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
