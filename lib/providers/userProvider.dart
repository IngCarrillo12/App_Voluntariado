import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/userModel.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/services/authService.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService(); // Instancia de AuthService

  UserModel? get user => _user;

  // Método para cargar la información del usuario
  Future<void> loadUserInfo() async {
    _user = await _authService.getUserInfoById();
    notifyListeners();
  }

  // Método para agregar actividad al historial del usuario
  Future<void> addActivityToHistory(String activityId) async {
    if (_user != null) {
      await _authService.addActivityToHistory(_user!.userId, activityId); // Llama al método desde la instancia
      _user = UserModel(
        userId: _user!.userId,
        nombreCompleto: _user!.nombreCompleto,
        correo: _user!.correo,
        telefono: _user!.telefono,
        rol: _user!.rol,
        horasAcumuladas: _user!.horasAcumuladas,
        actividadesRealizadas: _user!.actividadesRealizadas,
        historialParticipacion: [..._user!.historialParticipacion, activityId],
        sobreMi: user!.sobreMi
      );
      notifyListeners();
    }
  }

  Future<void> removeActivityFromHistory(String activityId) async {
  if (_user != null) {
    await _authService.removeActivityFromHistory(_user!.userId, activityId);
    _user = UserModel(
      userId: _user!.userId,
      nombreCompleto: _user!.nombreCompleto,
      correo: _user!.correo,
      telefono: _user!.telefono,
      rol: _user!.rol,
      horasAcumuladas: _user!.horasAcumuladas,
      actividadesRealizadas: _user!.actividadesRealizadas,
      historialParticipacion: _user!.historialParticipacion.where((id) => id != activityId).toList(),
      sobreMi: _user!.sobreMi
    );
    notifyListeners();
  }
}
  // Método para limpiar el usuario en el provider (opcional, por ejemplo, al cerrar sesión)
Future<void> signOut(BuildContext context) async {
  await _authService.signOut();
  _user = null;

  // Reinicia el estado del ActivitiesProvider
  Provider.of<ActivitiesProvider>(context, listen: false).resetData();

  notifyListeners();
}

Future<void> updateUserStatisticsForVolunteer(String userId, int activityDuration) async {
  try {
    if (userId.isEmpty) {
      throw Exception("El ID del usuario no puede estar vacío.");
    }
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userData = await userDoc.get();

    if (!userData.exists) {
      throw Exception("Usuario no encontrado en Firestore.");
    }

    final horasAcumuladas = (userData['horas_acumuladas'] ?? 0) as int;
    final actividadesRealizadas = (userData['actividades_realizadas'] ?? 0) as int;

    await _authService.updateUserStatistics(
      userId,
      horasAcumuladas + activityDuration,
      actividadesRealizadas + 1,
    );

    print("Estadísticas actualizadas correctamente para el usuario con ID: $userId");
  } catch (e) {
    print("Error al actualizar estadísticas del voluntario: $e");
  }
}
}
