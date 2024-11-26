import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Button/ElevatedButton.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/utils/location_service.dart';
import 'package:provider/provider.dart';

class PopularCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String activityId;
  final GeoPoint location;
  final bool button;

  const PopularCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.activityId,
    this.button = true,
  }) : super(key: key);

  @override
  _PopularCardState createState() => _PopularCardState();
}

class _PopularCardState extends State<PopularCard> {
  String _locationName = "Cargando..."; // Estado para almacenar la dirección legible

  @override
  void initState() {
    super.initState();
    _fetchLocationName();
  }

  Future<void> _fetchLocationName() async {
    final address = await LocationService.getAddressFromGeoPoint(widget.location);
    setState(() {
      _locationName = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    bool activityFound = user?.historialParticipacion.contains(widget.activityId) ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/activityDetailPage',
          arguments: widget.activityId,
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.imageUrl, width: 300, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(_locationName, style: const TextStyle(color: Colors.grey)),
            if (user?.rol != 'organizador' && widget.button == true)
              Button(
                text: activityFound ? "Cancelar Asistencia" : 'Asistir',
                onPressed: () async {
                  if (user == null) return;

                  final userInfo = {
                    'userId': user.userId,
                    'nombreCompleto': user.nombreCompleto,
                    'correo': user.correo,
                  };
                  if (activityFound) {
                    await userProvider.removeActivityFromHistory(widget.activityId);
                    await activitiesProvider.removeVolunteerFromActivity(
                      widget.activityId,
                      userInfo,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Has cancelado la asistencia')),
                    );
                  } else {
                    await userProvider.addActivityToHistory(widget.activityId);
                    await activitiesProvider.addVolunteerToActivity(
                      widget.activityId,
                      userInfo,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Te has inscrito en la actividad.')),
                    );
                  }
                  setState(() {}); // Para actualizar el estado del botón.
                },
                bgColor: Colors.pinkAccent,
                width: 100.0,
                paddingH: 5,
                paddingV: 5,
              ),
          ],
        ),
      ),
    );
  }
}
