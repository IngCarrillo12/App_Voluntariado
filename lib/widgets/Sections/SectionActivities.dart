import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Headers/SectionHeader.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';


class SectionActivities extends StatefulWidget {
  final List<Activity> activities;
  final String rol;

  const SectionActivities({
    super.key,
    required this.activities,
    required this.rol
  });

  @override
  _SectionActivitesState createState() => _SectionActivitesState();
}

class _SectionActivitesState extends State<SectionActivities> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: "Actividades disponibles"),
        const SizedBox(height: 12),
        // Mostrar las actividades cargadas
        Column(
          children: widget.activities.map((activity) {
            return ActivityCard(
              imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
              title: activity.titulo,
              location: activity.ubicacion,
              activityId: activity.id,
              button: widget.rol=='voluntario'?true:false,
            );
          }).toList(),
        ),
      ],
    );
  }
}
