import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Button/ButtonIcon.dart';
import 'package:frontend_flutter/Widgets/Button/ElevatedButton.dart';
import 'package:frontend_flutter/Widgets/Headers/HeaderForm.dart';
import 'package:frontend_flutter/Widgets/Inputs/InputForm.dart';
import 'package:frontend_flutter/Widgets/Logo.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/services/authService.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();

  // Variable para almacenar el rol seleccionado
  String _selectedRole = "voluntario"; // Valor inicial por defecto

  // Método para manejar el registro
  Future<void> _register() async {
    String nombre = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String telefono = _phoneController.text.trim();

    if (nombre.isNotEmpty && email.isNotEmpty && password.isNotEmpty && telefono.isNotEmpty) {
      User? user = await _authService.register(email, password, nombre, telefono, _selectedRole);

          if (user != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUserInfo(context);
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error en el registro, inténtalo de nuevo")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Logo(),
                const SizedBox(height: 10),
                const Headerform(
                  title: 'Create an Account!',
                  subtitle: 'Please fill this detail to create an account',
                ),
                const SizedBox(height: 32),

                // Username Field
                InputForm(
                  hintext: 'Nombre Completo',
                  icon: const Icon(Icons.person, color: Colors.grey),
                  bgColor: Colors.transparent,
                  borderColor: Colors.grey,
                  focusBorderColor: Colors.pinkAccent,
                  controller: _nameController,
                ),
                const SizedBox(height: 8),

                // Email Field
                InputForm(
                  hintext: 'Correo Electrónico',
                  icon: const Icon(Icons.email, color: Colors.grey),
                  controller: _emailController,
                  bgColor: Colors.transparent,
                  borderColor: Colors.grey,
                  focusBorderColor: Colors.pinkAccent,
                ),
                const SizedBox(height: 8),

                // Password Field
                InputForm(
                  hintext: 'Contraseña',
                  icon: const Icon(Icons.lock, color: Colors.grey),
                  controller: _passwordController,
                  bgColor: Colors.transparent,
                  borderColor: Colors.grey,
                  focusBorderColor: Colors.pinkAccent,
                  obscureText: true,
                ),
                const SizedBox(height: 8),

                // Phone Field
                InputForm(
                  hintext: 'Teléfono',
                  icon: const Icon(Icons.phone, color: Colors.grey),
                  controller: _phoneController,
                  bgColor: Colors.transparent,
                  borderColor: Colors.grey,
                  focusBorderColor: Colors.pinkAccent,
                ),
                const SizedBox(height: 8),

                // Rol Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        activeColor: Colors.pinkAccent,
                        title: const Text("Voluntario", style: TextStyle(color: Colors.black)),
                        value: "voluntario",
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Organizador", style: TextStyle(color: Colors.black)),
                        value: "organizador",
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Signup Button
                Button(text: 'Registrarse', bgColor: Colors.pink, onPressed: _register),
                const SizedBox(height: 12),

                // Or Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.pinkAccent)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Or",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.pinkAccent)),
                  ],
                ),
                const SizedBox(height: 12),

                // Social Login Buttons
                Buttonicon(
                  text: 'Login With Facebook',
                  icon: const Icon(Icons.facebook, color: Colors.white),
                  bgColor: Colors.blue,
                  colorText: Colors.white,
                  onPressed: (){},
                ),
                const SizedBox(height: 12),
               Buttonicon(
                  text: 'Login With Google',
                  icon: Icon(Icons.flag, color: Colors.red),
                  bgColor: Colors.white,
                  colorText: Colors.black,
                  onPressed: (){},
                ),
                const SizedBox(height: 5),

                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
