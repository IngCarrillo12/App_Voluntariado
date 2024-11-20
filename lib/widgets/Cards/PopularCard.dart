import 'package:flutter/material.dart';

class PopularEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;

  const PopularEventCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, width: 300, height: 200, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
