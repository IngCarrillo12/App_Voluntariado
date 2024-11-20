class UserModel {
  final String userId;
  final String nombreCompleto;
  final String correo;
  final String telefono;
  final String rol;
  final String sobreMi;
  final int horasAcumuladas;
  final int actividadesRealizadas;
  final List<dynamic> historialParticipacion;

  UserModel({
    required this.userId,
    required this.nombreCompleto,
    required this.correo,
    required this.telefono,
    required this.rol,
    required this.sobreMi,
    required this.horasAcumuladas,
    required this.actividadesRealizadas,
    required this.historialParticipacion,
  });

  // Factory method for creating a UserModel instance from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      userId: data['user_id'] ?? '',
      nombreCompleto: data['nombre_completo'] ?? '',
      correo: data['correo'] ?? '',
      telefono: data['telefono'] ?? '',
      rol: data['rol'] ?? '',
      sobreMi: data['sobre_mi'] ?? '',
      horasAcumuladas: data['horas_acumuladas'] ?? 0,
      actividadesRealizadas: data['actividades_realizadas'] ?? 0,
      historialParticipacion: data['historial_participacion'] ?? [],
    );
  }

  // Method to convert UserModel to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'nombre_completo': nombreCompleto,
      'correo': correo,
      'telefono': telefono,
      'rol': rol,
      'sobre_mi':sobreMi,
      'horas_acumuladas': horasAcumuladas,
      'actividades_realizadas': actividadesRealizadas,
      'historial_participacion': historialParticipacion,
    };
  }
}
