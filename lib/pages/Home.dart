import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/Widgets/Button/CategoryButton.dart';
import 'package:frontend_flutter/Widgets/SectionEvents.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/utils/CheckLocation.dart';
import 'package:frontend_flutter/utils/FilteredActivitiesByUser.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedCategory;
  String currentAddress = "Cargando ubicación...";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _fetchCurrentLocation();
  }

  Future<void> _loadData() async {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    await activitiesProvider.loadActivities();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      await checkLocation();


      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);
      final address = await LocationService.getAddressFromGeoPoint(geoPoint);

      setState(() {
        currentAddress = address;
      });
    } catch (e) {
      setState(() {
        currentAddress = "Error al obtener la ubicación";
      });
      print("Error al obtener la ubicación: $e");
    }
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
    final activities = activitiesProvider.activities;

    // Obtener las categorías únicas
    final categories = activities.map((activity) => activity.categoria).toSet().toList();

    // Filtrar actividades basadas en la categoría seleccionada
    final filteredActivities = FilteredActivitiesByUser.filter(
      activities.where((activity) {
        if (selectedCategory == null) return true;
        return activity.categoria == selectedCategory;
      }).toList(),
      user,
    ).take(7).toList();

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
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Barra de búsqueda
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Buscar actividades",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
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
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Actividades recomendadas
              SectionEvents(
                activities: filteredActivities,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
