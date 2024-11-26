import 'package:flutter/material.dart';


class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),

        
        TextButton(
          onPressed: () {Navigator.pushNamed(context, '/activitiesPage');},
          child: const Text("Ver mas", style: TextStyle(color: Colors.pinkAccent)),
        ),
      ],
    );
  }
}