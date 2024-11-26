import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Color bgColor;
  final double width;
  final double paddingH;
  final double paddingV;
  final double fontSize;
  final VoidCallback onPressed;


  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 140.0,
    this.paddingH = 10,
    this.paddingV = 10,
    this.fontSize = 14,
    this.bgColor = Colors.pinkAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
    );
  }
}
