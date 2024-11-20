import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/FilteredActivitiesByUser.dart';
import 'package:provider/provider.dart';

class ActivitiesFilterPage extends StatelessWidget {
  final List<Activity> activities;

  const ActivitiesFilterPage({super.key, required this.activities});
  
  @override
  Widget build(BuildContext context) {
      final userProvider = Provider.of<UserProvider>(context);
      final user = userProvider.user;
      final activitiesByUser = FilteredActivitiesByUser.filter(activities, user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Filtered Activities", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:activitiesByUser.isNotEmpty? 
        ListView(
          children: activitiesByUser.map((activity) {
            return ActivityCard(
              imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
              title: activity.titulo,
              location: activity.ubicacion,
              activityId: activity.id,
            );
          }).toList(),
        )
        :
        const Center(
          child: Text('No hay actividades con ese nombre', style: TextStyle(color: Colors.pinkAccent)),
        )
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
