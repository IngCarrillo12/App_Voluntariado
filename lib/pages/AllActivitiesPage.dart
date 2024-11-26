import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Inputs/InputOptionsForm.dart'; // Import del widget personalizado
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/FilteredActivitiesByUser.dart';
import 'package:frontend_flutter/widgets/Inputs/DateTimeInputForm.dart';
import 'package:provider/provider.dart';

class AllActivitiesPage extends StatefulWidget {
  const AllActivitiesPage({super.key});

  @override
  _AllActivitiesPageState createState() => _AllActivitiesPageState();
}

class _AllActivitiesPageState extends State<AllActivitiesPage> {
  String? selectedCategory;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  DateTime? selectedDateTime;
  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final activities = activitiesProvider.activities;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Obtener categorías únicas y agregar la opción "Todas"
    final categories = ["Todas", ...activities.map((activity) => activity.categoria).toSet()];

    // Filtrar actividades
    final filteredActivities = activities.where((activity) {
      // Filtrar por categoría si está seleccionada
      if (selectedCategory != null && selectedCategory != "Todas" && activity.categoria != selectedCategory) {
        return false;
      }

      // Filtrar por fecha ingresada
      if (selectedDate != null) {
        return activity.fechahora.year == selectedDate!.year &&
            activity.fechahora.month == selectedDate!.month &&
            activity.fechahora.day == selectedDate!.day;
      }

      return true; // Por defecto, incluir todas las actividades
    }).toList();

    final activitiesByUser = FilteredActivitiesByUser.filter(filteredActivities, user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Actividades",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros
           InputOptionsForm(
              hintText: "Selecciona categoría",
              icon: const Icon(Icons.category),
              options: categories,
              controller: categoryController,
              
              onChanged: (value) {
                setState(() {
                  selectedCategory = value; 
                });
              }
            ),

            const SizedBox(height: 16),
          Row(
  children: [
    Expanded(
      child: DateTimeInputForm(
        hintText: "Selecciona una fecha ",
        icon: const Icon(Icons.calendar_today),
        controller: dateController,
        bgColor: Colors.white,
        onDateTimeChanged: (DateTime dateTime) {
          setState(() {
            selectedDate = dateTime; 
          });
        },
      ),
    ),
    const SizedBox(width: 8),
    ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = null; // Opcional: Resetear categoría al filtrar por fecha
        });
      },
      child: const Text("Filtrar"),
    ),
  ],
),

            const SizedBox(height: 16),
            // Lista de actividades filtradas
            Expanded(
              child: ListView.builder(
                itemCount: activitiesByUser.length,
                itemBuilder: (context, index) {
                  if (user?.rol == 'voluntario') {
                    final activity = activitiesByUser[index];
                    return ActivityCard(
                      imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
                      title: activity.titulo,
                      location: activity.ubicacion,
                      activityId: activity.id,
                    );
                  } else {
                    final activity = filteredActivities[index];
                    return ActivityCard(
                      imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
                      title: activity.titulo,
                      location: activity.ubicacion,
                      activityId: activity.id,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
