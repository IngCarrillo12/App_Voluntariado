import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String hintext;
  final Color bgColor;
  final Color plhColor;
  final Color txtColor;
  final Color borderColor;
  final Color focusBorderColor; // Nuevo parámetro para el borde cuando está en focus
  final Icon icon;
  final TextEditingController? controller;
  final bool obscureText;
  final String inputType;

  const InputForm({
    super.key,
    required this.hintext,
    this.plhColor = Colors.grey,
    this.bgColor = Colors.black26,
    this.txtColor = Colors.black,
    this.borderColor = Colors.pinkAccent,
    this.focusBorderColor = Colors.blue, // Color predeterminado para el borde en focus
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.inputType = 'string',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType.toLowerCase() == 'number' ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintext,
        hintStyle: TextStyle(color: plhColor),
        filled: true,
        fillColor: bgColor,
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusBorderColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      style: TextStyle(color: txtColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '*Este campo es obligatorio';
        }
        if (inputType == 'number' && int.tryParse(value) == null) {
          return 'Por favor ingrese un número válido';
        }
        return null;
      },
    );
  }
}
