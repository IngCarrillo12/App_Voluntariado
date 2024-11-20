import 'package:flutter/material.dart';


class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const CategoryButton({super.key, required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.grey),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}