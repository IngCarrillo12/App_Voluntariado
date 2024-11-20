import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_flutter/utils/CheckLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerMap extends StatefulWidget {
  @override
  _LocationPickerMapState createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  LatLng? _currentLocation; // Para guardar la ubicación actual
  LatLng? _selectedLocation; // Ubicación seleccionada por el usuario
  late final MapController _mapController; // Controlador del mapa
  bool _loading = true; // Indica si se está cargando la ubicación
  bool _mapInitialized = false; // Verifica si el mapa fue inicializado
  TextEditingController _searchController = TextEditingController(); // Para buscar lugares

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation(); // Obtén la ubicación al iniciar
  }

  Future<void> _getCurrentLocation() async {
    try {
        await checkLocation();
      // Configuración de precisión para obtener la ubicación
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      // Obtén la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
        _mapInitialized = true; // Marca que el mapa está listo
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener ubicación: $e")),
      );
    }
  }

  Future<void> _searchLocation() async {
    String query = _searchController.text;
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, introduce un nombre o dirección.")),
      );
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng searchedLocation = LatLng(location.latitude, location.longitude);

        setState(() {
          _selectedLocation = searchedLocation;
          _mapController.move(searchedLocation, 15.0); // Mueve el mapa al resultado
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se encontró la ubicación.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar ubicación: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecciona una ubicación"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null) {
                Navigator.pop(context, _selectedLocation); // Devuelve la ubicación
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selecciona una ubicación primero")),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Buscar lugar",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchLocation, // Buscar ubicación
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator()) // Indicador de carga
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: _currentLocation, // Solo se centra si está inicializado
                      zoom: 15.0,
                      maxZoom: 18.0,
                      minZoom: 5.0,
                      onTap: (tapPosition, point) {
                        setState(() {
                          _selectedLocation = point; // Guarda la ubicación seleccionada
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      if (_selectedLocation != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedLocation!,
                              width: 80,
                              height: 80,
                              builder: (context) => Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}