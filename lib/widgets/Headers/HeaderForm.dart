import 'package:flutter/material.dart';

class Headerform extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subtitleColor;
  const Headerform({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleColor = Colors.pinkAccent,
    this.subtitleColor = Colors.black
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
               Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 16,
                ),
              ),
      ],
    );
  }
}