import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Headers/SectionHeader.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';



class SectionPopularActivities extends StatefulWidget {
  final List<Activity> activities;

  const SectionPopularActivities({
    super.key,
    required this.activities, // Recibir las actividades como parámetro requerido
  });

  @override
  _SectionPopularActivitesState createState() => _SectionPopularActivitesState();
}

class _SectionPopularActivitesState extends State<SectionPopularActivities> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: "Actividades Populares"),
        const SizedBox(height: 12),
        Column(
          children: widget.activities.map((activity) {
            return ActivityCard(
              imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
              title: activity.titulo,
              location: activity.ubicacion,
              activityId: activity.id,
            );
          }).toList(),
        ),
      ],
    );
  }
}
