import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/FilteredActivitiesByUser.dart';
import 'package:frontend_flutter/widgets/Button/ElevatedButton.dart';
import 'package:provider/provider.dart';

class UserActivitiesPage extends StatefulWidget {
  const UserActivitiesPage({super.key});

  @override
  _UserActivitiesPageState createState() => _UserActivitiesPageState();
}

class _UserActivitiesPageState extends State<UserActivitiesPage> {
  String? selectedCategory;
  String selectedFilter = "activas";
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final activities = activitiesProvider.activities;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final categories = activities.map((activity) => activity.categoria).toSet().toList();

    // Filtrar actividades
    final activitiesByUserVolunteer = activities.where((activity) {
      final isInHistory = user?.historialParticipacion.contains(activity.id) == true;
      return isInHistory ;
    }).toList();
    final activitiesByUserOrganizer = FilteredActivitiesByUser.filter(activities, user);
    final filteredActivitiesVolunteer = activitiesByUserVolunteer.where((activity) {
      // Filtrar por categoría si está seleccionada
      if (selectedCategory != null && activity.categoria != selectedCategory) {
        return false;
      }

      // Filtrar por tipo de actividades
      if (selectedFilter == "activas") {
        return activity.fechahora.isAfter(DateTime.now());
      } else if (selectedFilter == "pasadas") {
        return activity.fechahora.isBefore(DateTime.now());
      }

      // Filtrar por fecha ingresada
      if (selectedDate != null) {
        return activity.fechahora.year == selectedDate!.year &&
            activity.fechahora.month == selectedDate!.month &&
            activity.fechahora.day == selectedDate!.day;
      }

      return true; // Por defecto, incluir todas las actividades
    }).toList();
    final filteredActivitiesOrganizer = activitiesByUserOrganizer.where((activity) {
      // Filtrar por categoría si está seleccionada
      if (selectedCategory != null && activity.categoria != selectedCategory) {
        return false;
      }

      // Filtrar por tipo de actividades
      if (selectedFilter == "activas") {
        return activity.fechahora.isAfter(DateTime.now());
      } else if (selectedFilter == "pasadas") {
        return activity.fechahora.isBefore(DateTime.now());
      }

      // Filtrar por fecha ingresada
      if (selectedDate != null) {
        return activity.fechahora.year == selectedDate!.year &&
            activity.fechahora.month == selectedDate!.month &&
            activity.fechahora.day == selectedDate!.day;
      }

      return true; // Por defecto, incluir todas las actividades
    }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Actividades",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text("Categoría"),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                        selectedDate = null; 
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: "activas", child: Text("Activas")),
                      DropdownMenuItem(value: "pasadas", child: Text("Pasadas")),
                      DropdownMenuItem(value: "todas", child: Text("Todas")),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Input para fecha
            Row(
              children: [
                Expanded(
  child: TextField(
    controller: dateController,
    readOnly: true,
    onTap: () async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        setState(() {
          selectedDate = date;
          dateController.text =
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        });
      }
    },
    decoration: InputDecoration(
      hintText: "Fecha (YYYY-MM-DD)",
      hintStyle: const TextStyle(color: Colors.grey), // Estilo del texto de marcador
      filled: true, // Activar el fondo
      fillColor: Colors.white, // Fondo blanco
      prefixIcon: const Icon(Icons.calendar_today, color: Colors.pinkAccent), // Icono similar al `DateTimeInputForm`
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.pinkAccent), // Borde cuando no está enfocado
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.pinkAccent), // Borde cuando está enfocado
      ),
    ),
    style: const TextStyle(color: Colors.black), // Estilo del texto
  ),
),
                const SizedBox(width: 8),
                Button(
                  text: 'Filtrar',
                  onPressed: () {
                    setState(() {
                      selectedCategory = null;
                      selectedFilter = "todas";
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            user?.rol == 'organizador'?
            Expanded(
              child: ListView.builder(
                itemCount: filteredActivitiesOrganizer.length,
                itemBuilder: (context, index) {
                  final activity = filteredActivitiesOrganizer[index];
                  return ActivityCard(
                    imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
                    title: activity.titulo,
                    location: activity.ubicacion,
                    activityId: activity.id,
                  );
                },
              ),
            )
            :
            Expanded(
              child: ListView.builder(
                itemCount: filteredActivitiesVolunteer.length,
                itemBuilder: (context, index) {
                  final activity = filteredActivitiesVolunteer[index];
                  return ActivityCard(
                    imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
                    title: activity.titulo,
                    location: activity.ubicacion,
                    activityId: activity.id,
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
