import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';

class ActivitiesService {
  final CollectionReference _activitiesCollection =
      FirebaseFirestore.instance.collection('activities');

  // Método para agregar una actividad a Firestore
  Future<String?> addActivity(Activity activity) async {
    try {
      await _activitiesCollection.add(activity.toMap());
    } catch (e) {
      print("Error adding activity: $e");
    }
  }

  // Método para obtener todas las actividades de Firestore
  Future<List<Activity>> getActivities() async {
    try {
      QuerySnapshot snapshot = await _activitiesCollection.get();
      return snapshot.docs.map((doc) {
        return Activity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching activities: $e");
      return [];
    }
  }

  // Método para eliminar una actividad por ID
  Future<void> deleteActivity(String activityId) async {
    try {
      await _activitiesCollection.doc(activityId).delete();
      print("Activity deleted successfully!");
    } catch (e) {
      print("Error deleting activity: $e");
    }
  }

  Future<void> updateActivity(Activity activity) async {
    try {
      await _activitiesCollection.doc(activity.id).update(activity.toMap());
      print("Activity updated successfully!");
    } catch (e) {
      print("Error updating activity: $e");
    }
  }

  Future<void> addVolunteer(String activityId, Map<String, dynamic> volunteer) async {
    try {
      await _activitiesCollection.doc(activityId).update({
        'voluntarios': FieldValue.arrayUnion([volunteer]),
      });
    } catch (e) {
      print("Error al añadir voluntario: $e");
    }
  }
Future<void> removeVolunteerFromActivity(String activityId, Map<String, dynamic> volunteerInfo) async {
  try {
    await _activitiesCollection.doc(activityId).update({
      'voluntarios': FieldValue.arrayRemove([volunteerInfo]),
    });
  } catch (e) {
    print("Error al eliminar voluntario de la actividad: $e");
  }
}
  // Método para actualizar asistencia de un voluntario
  Future<void> updateAttendance(String activityId, String userId, String status) async {
  try {
    final activityDoc = _activitiesCollection.doc(activityId);
    await activityDoc.update({
      'asistencia.$userId': status,
    });
    print("Asistencia actualizada correctamente para el usuario $userId en la actividad $activityId.");
  } catch (e) {
    print("Error al actualizar la asistencia: $e");
  }
}

}
