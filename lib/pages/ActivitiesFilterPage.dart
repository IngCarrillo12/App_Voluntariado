import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/FilteredActivitiesByUser.dart';
import 'package:provider/provider.dart';

class ActivitiesFilterPage extends StatefulWidget {
  final List<Activity> activities;

  const ActivitiesFilterPage({super.key, required this.activities});

  @override
  _ActivitiesFilterPageState createState() => _ActivitiesFilterPageState();
}

class _ActivitiesFilterPageState extends State<ActivitiesFilterPage> {
  String? selectedCategory;
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Obtener categorías únicas
    final categories = widget.activities.map((activity) => activity.categoria).toSet().toList();

    // Filtrar actividades
    final activitiesByUser = FilteredActivitiesByUser.filter(widget.activities, user);
    final filteredActivities = activitiesByUser.where((activity) {
      // Filtrar por categoría si está seleccionada
      if (selectedCategory != null && activity.categoria != selectedCategory) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Filtered Activities",
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
                    decoration: const InputDecoration(
                      labelText: "Fecha (YYYY-MM-DD)",
                      border: OutlineInputBorder(),
                    ),
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
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = null; // Resetear categoría al filtrar por fecha
                    });
                  },
                  child: const Text("Filtrar"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lista de actividades filtradas
            Expanded(
              child: filteredActivities.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
                        return ActivityCard(
                          imageUrl: activity.imageUrl ?? "https://via.placeholder.com/150",
                          title: activity.titulo,
                          location: activity.ubicacion,
                          activityId: activity.id,
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No hay actividades con los filtros seleccionados',
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
