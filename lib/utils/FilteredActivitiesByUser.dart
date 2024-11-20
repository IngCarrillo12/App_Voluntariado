import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/models/userModel.dart';

class FilteredActivitiesByUser {
  // Método estático para filtrar actividades
  static List<Activity> filter(List<Activity> activities, UserModel? user) {
    return activities.where((activity) {
      final isNotInHistory = user?.historialParticipacion.contains(activity.id) == false;
      final isInFuture = activity.fechahora.isAfter(DateTime.now());
      final hasSpace = activity.voluntarios.length < activity.maxVoluntarios;
      return isNotInHistory && isInFuture && hasSpace;
    }).toList();
  }
}
