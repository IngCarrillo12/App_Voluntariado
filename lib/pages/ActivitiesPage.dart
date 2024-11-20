import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/FilteredActivitiesByUser.dart';
import 'package:provider/provider.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final activities = activitiesProvider.activities;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final filteredActivities = FilteredActivitiesByUser.filter(activities, user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Actividades", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: filteredActivities.map((activity){
              return ActivityCard(imageUrl: activity.imageUrl?? "https://via.placeholder.com/150", title: activity.titulo, location: activity.ubicacion, activityId: activity.id);
            }).toList(),
          ),
          ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
