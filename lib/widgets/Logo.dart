import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
         Icon(
                Icons.event,
                color: Colors.pinkAccent,
                size: 80.0,
              ),
              SizedBox(height: 10),
              Text(
                "CITY EVENT",
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
}