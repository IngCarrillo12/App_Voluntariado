import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/services/activitiesService.dart';

class ActivitiesProvider extends ChangeNotifier {
  List<Activity> _activities = [];
  final ActivitiesService _activitiesService = ActivitiesService();
  bool _isDataLoaded = false; // Indicador de si los datos ya fueron cargados

  List<Activity> get activities => _activities;

  bool get isDataLoaded => _isDataLoaded;

  // Cargar actividades si no han sido cargadas previamente
  Future<void> loadActivities() async {
    if (!_isDataLoaded) {
      _activities = await _activitiesService.getActivities();
      _isDataLoaded = true; // Marcar los datos como cargados
      notifyListeners();
    }
  }

  // Forzar recarga de actividades (por ejemplo, en pull-to-refresh)
  Future<void> refreshActivities() async {
    _activities = await _activitiesService.getActivities();
    _isDataLoaded = true; // Marcar los datos como cargados
    notifyListeners();
  }

  // Agregar actividad y recargar
  Future<void> addActivity(Activity activity) async {
    final String? activityId = await _activitiesService.addActivity(activity);
    if (activityId != null) {
      await refreshActivities(); // Forzar recarga de Firestore
    }
  }
void resetData() {
  _activities = [];
  _isDataLoaded = false;
  notifyListeners();
}
  Future<void> deleteActivity(String activityId) async {
    await _activitiesService.deleteActivity(activityId);
    _activities.removeWhere((activity) => activity.id == activityId);
    notifyListeners();
  }

  // Obtener actividad por ID
  Activity? getActivityById(String id) {
    for (var activity in _activities) {
      if (activity.id == id) {
        return activity;
      }
    }
    return null;
  }

  Future<void> updateActivity(Activity activity) async {
    await _activitiesService.updateActivity(activity);
    await refreshActivities(); // Forzar recarga de actividades
    notifyListeners();
  }

  Future<void> addVolunteerToActivity(String activityId, Map<String, dynamic> volunteer) async {
    try {
      await _activitiesService.addVolunteer(activityId, volunteer);
      final activityIndex = _activities.indexWhere((activity) => activity.id == activityId);
      if (activityIndex != -1) {
        _activities[activityIndex].voluntarios.add(volunteer);
        notifyListeners();
      }
    } catch (e) {
      print("Error al agregar voluntario: $e");
    }
  }
  Future<void> addFeedbackToActivity(String activityId, Map<String, dynamic> feedback) async {
    try {
      await _activitiesService.addFeedback(activityId, feedback);
      final activityIndex = _activities.indexWhere((activity) => activity.id == activityId);
      if (activityIndex != -1) {
        _activities[activityIndex].feedback.add(feedback);
        notifyListeners();
      }
    } catch (e) {
      print("Error al agregar voluntario: $e");
    }
  }

  Future<void> removeVolunteerFromActivity(String activityId, Map<String, dynamic> volunteerInfo) async {
    await _activitiesService.removeVolunteerFromActivity(activityId, volunteerInfo);
    notifyListeners();
  }

  Future<void> updateAttendance(Activity activity, String userId, String status) async {
    try {
      // Actualizar en Firestore
      await _activitiesService.updateAttendance(activity.id, userId, status);

      // Actualizar estado local de la actividad
      final activityIndex = _activities.indexWhere((a) => a.id == activity.id);
      if (activityIndex != -1) {
        _activities[activityIndex].asistencia[userId] = status;
        notifyListeners();
      }
    } catch (e) {
      print("Error al actualizar la asistencia: $e");
    }
  }
}
