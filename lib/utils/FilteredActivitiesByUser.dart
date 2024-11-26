import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/models/userModel.dart';

class FilteredActivitiesByUser {
  static List<Activity> filter(List<Activity> activities, UserModel? user) {
    // Si el usuario no está definido, retornar una lista vacía
    if (user == null) return [];

    // Para organizadores, mostrar todas las actividades
    if (user.rol == 'organizador') {
      return activities;
    }

    // Para voluntarios, aplicar los filtros
    return activities.where((activity) {
      final isNotInHistory = user.historialParticipacion.contains(activity.id) == false;
      final isInFuture = activity.fechahora.isAfter(DateTime.now());
      final hasSpace = activity.voluntarios.length < activity.maxVoluntarios;
      return isNotInHistory && isInFuture && hasSpace;
    }).toList();
  }
}
