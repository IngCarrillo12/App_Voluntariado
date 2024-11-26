import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/utils/location_service.dart';
import 'package:frontend_flutter/pages/CreateOrEditActivityPage.dart';
import 'package:frontend_flutter/Widgets/Button/ButtonIcon.dart';
import 'package:frontend_flutter/Widgets/Button/ElevatedButton.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';

class ActivityDetailPage extends StatefulWidget {
  final String activityId;

  const ActivityDetailPage({Key? key, required this.activityId}) : super(key: key);

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  String? _locationName; // Variable para guardar el nombre del lugar
  bool _isLoadingLocation = true; // Indica si se está cargando la ubicación

  @override
  void initState() {
    super.initState();
    _fetchLocationName();
  }

  bool _isDateCurrentOrFuture(DateTime date) {
    final now = DateTime.now();
    final activityDate = DateTime(date.year, date.month, date.day, date.hour, date.minute);
    return now.isAfter(activityDate) || now.isAtSameMomentAs(activityDate);
  }
 
  Future<void> _updateAttendance(
  BuildContext context,
  ActivitiesProvider activitiesProvider,
  UserProvider userProvider,
  String voluntarioId,
  String status,
  Activity activity,
) async {
  try {
    // Actualizar la asistencia en el provider
    await activitiesProvider.updateAttendance(activity, voluntarioId, status);

    // Si el estado es 'asistió', actualizar estadísticas del voluntario en Firestore
    if (status == 'asistió') {
      await userProvider.updateUserStatisticsForVolunteer(voluntarioId, activity.duracion);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asistencia registrada con éxito.')),
      );
    } else if (status == 'ausente') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ausencia registrada con éxito.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al registrar la asistencia.')),
    );
    print("Error al registrar la asistencia: $e");
  }
}


  Future<void> _fetchLocationName() async {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    final activity = activitiesProvider.getActivityById(widget.activityId);

    if (activity != null) {
      final locationName =
          await LocationService.getAddressFromGeoPoint(activity.ubicacion);

      setState(() {
        _locationName = locationName;
        _isLoadingLocation = false;
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final activity = activitiesProvider.getActivityById(widget.activityId);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
   bool activityFound = user?.historialParticipacion.contains(widget.activityId) ?? false;
    if (activity == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Detalles de la actividad",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: Text("Actividad no encontrada")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalles de la actividad",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Image.network(
              activity.imageUrl ?? 'https://via.placeholder.com/300',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
  top: 250,
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  activity.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(
              _isLoadingLocation
                  ? "Cargando ubicación..."
                  : _locationName ?? "Ubicación no disponible",
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(
              "${activity.fechahora.day}/${activity.fechahora.month}/${activity.fechahora.year}",
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.hourglass_bottom_sharp, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(
              "Duración: ${activity.duracion} Min",
            ),
          ],
        ),
                  const SizedBox(height: 16),
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(activity.descripcion, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                 // Botones de acción según el rol del usuario
                 if(user?.rol == 'voluntario' && !_isDateCurrentOrFuture(activity.fechahora))
                      Button(
                          text: activityFound ? 'Cancelar asistencia' : 'Asistir',
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
                                  widget.activityId, userInfo);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Has cancelado la asistencia')));
                            } else {
                              await userProvider.addActivityToHistory(widget.activityId);
                              await activitiesProvider.addVolunteerToActivity(
                                  widget.activityId, userInfo);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Te has inscrito en la actividad.')));
                            }
                          },
                          bgColor: Colors.pinkAccent,
                        ),
                      if(user?.rol == 'organizador')
                          Column(
                        children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Buttonicon(
                                text: 'Eliminar',
                                icon: const Icon(Icons.delete, color: Colors.white),
                                bgColor: Colors.pinkAccent,
                                colorText: Colors.white,
                                onPressed: () async {
                                  await activitiesProvider.deleteActivity(widget.activityId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Actividad eliminada con éxito')),
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Buttonicon(
                                text: 'Editar',
                                icon: const Icon(Icons.edit, color: Colors.white),
                                bgColor: Colors.pinkAccent,
                                colorText: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateOrEditActivityPage(activity: activity),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          ),
                        ],
                        ),

                  if (user?.rol == 'organizador' && _isDateCurrentOrFuture(activity.fechahora))
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de Asistencia
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Asistencia",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Lista de voluntarios y asistencia
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Evita conflictos de scroll
                      itemCount: activity.voluntarios.length,
                      itemBuilder: (context, index) {
                        final voluntario = activity.voluntarios[index];
                        return ListTile(
                          title: Text(voluntario['nombreCompleto']),
                          trailing: DropdownButton<String>(
                            value: activity.asistencia[voluntario['userId']] ?? "pendiente",
                            items: const [
                              DropdownMenuItem(value: "asistió", child: Text("Asistió")),
                              DropdownMenuItem(value: "ausente", child: Text("Ausente")),
                              DropdownMenuItem(value: "pendiente", child: Text("Pendiente")),
                            ],
                            onChanged: (value) async {
                              if (value != null) {
                                await _updateAttendance(
                                  context,
                                  activitiesProvider,
                                  userProvider,
                                  voluntario['userId'],
                                  value,
                                  activity,
                );
              }
            },
          ),
        );
      },
    ),
  ],
)
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
