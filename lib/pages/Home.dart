import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Inputs/InputForm.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/Widgets/Button/CategoryButton.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/FilteredActivitiesByUser.dart';
import 'package:frontend_flutter/widgets/Sections/SectionActivities.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend_flutter/utils/location_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedCategory;
  String currentAddress = "Cargando ubicación...";
  bool isFetchingLocation = false;
  final TextEditingController _searchController = TextEditingController();

  // Variable para almacenar el Future de las actividades
  late Future<void> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _activitiesFuture = _loadActivities(); // Cargar actividades al inicio
  }

  Future<void> _initializeData() async {
    if (currentAddress == "Cargando ubicación..." && !isFetchingLocation) {
      await _fetchCurrentLocation();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      isFetchingLocation = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      String address = await LocationService.getAddressFromGeoPoint(
        GeoPoint(position.latitude, position.longitude),
      );

      setState(() {
        currentAddress = address;
      });
    } catch (e) {
      setState(() {
        currentAddress = "Error al obtener la ubicación";
      });
      print("Error al obtener la ubicación: $e");
    } finally {
      setState(() {
        isFetchingLocation = false;
      });
    }
  }

  Future<void> _loadActivities() async {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    await activitiesProvider.refreshActivities();
  }

  void _performSearch(BuildContext context, String searchText, List<Activity> activities) {
    final searchResults = activities.where((activity) {
      return activity.titulo.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    Navigator.pushNamed(
      context,
      '/activitiesFilterPage',
      arguments: searchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.pinkAccent),
                const SizedBox(width: 8),
                Text(
                  currentAddress,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _activitiesFuture, // Usar el Future almacenado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar actividades"));
          }

          // Obtener actividades filtradas
          final activities = activitiesProvider.activities;

          // Obtener categorías únicas (incluyendo "Todas")
          final categories = ["Todas", ...activities.map((activity) => activity.categoria).toSet()];

          // Filtrar actividades por usuario y categoría
          final activitiesByUser = FilteredActivitiesByUser.filter(activities, user);

          final filteredActivities = activitiesByUser.where((activity) {
            // Aplicar el filtro de categoría si está seleccionado
            if (selectedCategory == null || selectedCategory == "Todas") return true;
            return activity.categoria == selectedCategory;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              // Al recargar, actualizar las actividades y reconstruir la vista
              await activitiesProvider.refreshActivities();
              setState(() {
                _activitiesFuture = _loadActivities();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InputForm(
                          controller: _searchController,
                          hintext: 'Buscar actividad',
                          icon: const Icon(Icons.search),
                          bgColor: Colors.transparent,
                          borderColor: Colors.grey,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _performSearch(context, _searchController.text, activities);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Categorías
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CategoryButton(
                            label: category,
                            icon: Icons.category,
                            onPressed: () {
                              setState(() {
                                selectedCategory = category == "Todas" ? null : category;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Actividades recomendadas
                  SectionActivities(
                    activities: filteredActivities,
                    rol: user.rol,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
