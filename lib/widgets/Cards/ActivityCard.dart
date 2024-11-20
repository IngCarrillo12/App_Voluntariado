import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Button/ElevatedButton.dart';
import 'package:frontend_flutter/utils/location_service.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';

class ActivityCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final GeoPoint location;
  final String activityId;
  final bool button;
  const ActivityCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.activityId,
    this.button = true,
  });

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  String _locationName = "Cargando..."; // Estado para almacenar la dirección legible

  @override
  void initState() {
    super.initState();
    _fetchLocationName();
  }

  Future<void> _fetchLocationName() async {
    final address = await LocationService.getAddressFromGeoPoint(widget.location);
    setState(() {
      _locationName = address; // Actualiza la dirección legible
    });
  }

  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/activityDetailPage',
          arguments: widget.activityId,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          title: Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _locationName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          trailing: user?.rol != 'organizador' && widget.button == true
              ? Button(
                  text: 'Asistir',
                  onPressed: () async {
                    final userInfo = {
                      'userId': user?.userId,
                      'nombreCompleto': user?.nombreCompleto,
                      'correo': user?.correo,
                    };
                    await userProvider.addActivityToHistory(widget.activityId);
                    await activitiesProvider.addVolunteerToActivity(widget.activityId, userInfo);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Te has inscrito en la actividad.')),
                    );
                  },
                  bgColor: Colors.pinkAccent,
                  width: 100.0,
                  paddingH: 5,
                  paddingV: 5,
                )
              : null,
        ),
      ),
    );
  }
}
