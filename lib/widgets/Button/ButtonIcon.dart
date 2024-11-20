import 'package:flutter/material.dart';

class Buttonicon extends StatelessWidget {
  final String text;
  final Icon icon;
  final Color bgColor;
  final Color colorText;
  final double width;
  final VoidCallback onPressed;
  const Buttonicon({
    super.key,
   required this.text, 
   required this.icon, 
   required this.bgColor, 
   required this.colorText, 
   required this.onPressed,
   this.width = 300.0,
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon:  icon,
        label:Text(text,style: TextStyle(color: colorText),),
      ),
    );
  }
}