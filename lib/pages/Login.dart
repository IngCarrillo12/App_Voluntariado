import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Button/ButtonIcon.dart';
import 'package:frontend_flutter/Widgets/Button/ElevatedButton.dart';
import 'package:frontend_flutter/Widgets/Headers/HeaderForm.dart';
import 'package:frontend_flutter/Widgets/Inputs/InputForm.dart';
import 'package:frontend_flutter/Widgets/Logo.dart';
import 'package:frontend_flutter/Widgets/Button/TextButton.dart';
import 'package:frontend_flutter/services/authService.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Método para manejar el inicio de sesión
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      User? user = await _authService.signIn(email, password);

      if (user != null) {
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error en el inicio de sesión, verifica tus credenciales")),
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
          padding: const EdgeInsets.all(16.0),
          child: Center(
          child: Form(
            key: _formKey, // Asociar el formulario con la clave global
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Logo(),
                const SizedBox(height: 32),
                const Headerform(
                  title: 'Welcome Back!',
                  subtitle: 'Use Credentials to access your account',
                ),
                const SizedBox(height: 32),

                // Email Field
                InputForm(
                  hintext: 'Enter Email',
                  icon: const Icon(Icons.person, color: Colors.grey),
                  controller: _emailController,
                  bgColor: Colors.transparent,
                  borderColor: Colors.grey,
                  focusBorderColor: Colors.pinkAccent,
                ),
                const SizedBox(height: 16),

                // Password Field
                InputForm(
                  hintext: 'Enter Password',
                  icon: const Icon(Icons.lock, color: Colors.grey),
                  controller: _passwordController,
                  bgColor: Colors.transparent,
                  borderColor: Colors.grey,
                  focusBorderColor: Colors.pinkAccent,
                  obscureText: true,
                ),
                const SizedBox(height: 2),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: Textbutton(text: 'Forgot Password?', onPressed: (){}),
                ),

                // Login Button
                Button(
                  text: 'Login',
                  onPressed: _signIn,
                  bgColor: Colors.pinkAccent,
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 16),

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
                const SizedBox(height: 24),

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
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Signup",
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
        ),
      ),
    );

  }
}
