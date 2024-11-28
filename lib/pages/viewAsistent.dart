import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/pages/FeedbackDetail.dart';
import 'package:frontend_flutter/pages/FeedbackForm.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:frontend_flutter/widgets/Button/ElevatedButton.dart';
import 'package:provider/provider.dart';

class AsistenciaWidget extends StatelessWidget {
  final Activity activity; 

  AsistenciaWidget({required this.activity});

  Future<void> _updateAttendance(BuildContext context, String userId, String value, Activity activity) async {
    try {
      final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await activitiesProvider.updateAttendance(activity, userId, value);
      if (value == 'asistió') {
        await userProvider.updateUserStatisticsForVolunteer(userId, activity.duracion);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asistencia registrada con éxito.')),
        );
      } else if (value == 'ausente') {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tomar asistencia",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Asistencia",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activity.voluntarios.length,
              itemBuilder: (context, index) {
                final voluntario = activity.voluntarios[index];
                final feedback = activity.feedback.firstWhere(
                  (f) => f['userId'] == voluntario['userId'],
                  orElse: () => null,
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          voluntario['nombreCompleto'][0].toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        voluntario['nombreCompleto'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround, // Centra verticalmente los elementos
                        children: [
                          Flexible(
                            flex: 1,
                            child: DropdownButton<String>(
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
                                    voluntario['userId'],
                                    value,
                                    activity,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // Validamos si feedback existe antes de mostrar el botón
                          feedback != null
                              ? Flexible(
                                  flex: 2,
                                  child: Button(
                                    width: 120.0,
                                    paddingV: 0.0,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Feedback de ${voluntario['nombreCompleto']}"),
                                            content: FeedbackDetail(feedback: feedback),
                                            actions: [
                                              TextButton(
                                                child: const Text("Cerrar"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    text: "Ver Feedback",
                                  ),
                                )
                              : SizedBox.shrink(), // Si no hay feedback, no mostramos el botón
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
