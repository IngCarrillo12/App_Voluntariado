import 'package:flutter/material.dart';

class Textbutton extends StatelessWidget {
  final String text;
 final VoidCallback onPressed;
  const Textbutton({
    super.key,
    required this.text,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
        text,
        style: const TextStyle(color: Colors.pinkAccent),
        ),
        );
  }
}