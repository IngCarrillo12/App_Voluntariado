import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Headers/SectionHeader.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';


class SectionEvents extends StatefulWidget {
  final List<Activity> activities;

  const SectionEvents({
    super.key,
    required this.activities, // Recibir las actividades como parámetro requerido
  });

  @override
  _SectionEventsState createState() => _SectionEventsState();
}

class _SectionEventsState extends State<SectionEvents> {
  
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
            );
          }).toList(),
        ),
      ],
    );
  }
}
