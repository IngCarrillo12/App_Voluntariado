import 'package:flutter/material.dart';

class MultilineInputForm extends StatelessWidget {
  final String hintText;
  final Color bgColor;
  final Color placeholderColor;
  final Color textColor;
  final Color borderColor;
  final TextEditingController? controller;

  const MultilineInputForm({
    Key? key,
    required this.hintText,
    this.placeholderColor = Colors.grey,
    this.bgColor = Colors.black26,
    this.textColor = Colors.black,
    this.borderColor = Colors.pinkAccent,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: placeholderColor),
        filled: true,
        fillColor: bgColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
      style: TextStyle(color: textColor),
    );
  }
}
