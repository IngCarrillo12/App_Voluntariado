import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:provider/provider.dart';

class UserSpecificActivitiesPage extends StatelessWidget {
  const UserSpecificActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final activities = activitiesProvider.activities;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Filtrar actividades según el rol del usuario
    final filteredActivities = user?.rol == 'organizador'
        ? activities
        : activities.where((activity) {
            return user?.historialParticipacion.contains(activity.id) ?? false;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Mis Actividades",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Verifica si hay una ruta previa en la pila o regresa al home
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, '/home');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredActivities.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: filteredActivities.map((activity) {
                    return ActivityCard(
                      imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
                      title: activity.titulo,
                      location: activity.ubicacion,
                      activityId: activity.id,
                    );
                  }).toList(),
                ),
              )
            : const Center(
                child: Text(
                  "No hay actividades disponibles.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
