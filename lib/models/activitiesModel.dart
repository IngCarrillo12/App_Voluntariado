
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fechahora;
  final GeoPoint ubicacion; // Cambiado a GeoPoint
  final String categoria;
  final int maxVoluntarios;
  final String? imageUrl;
  final int duracion;
  final List<dynamic> voluntarios;
  final Map<String, String> asistencia;
  final List<dynamic> feedback;

  Activity({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechahora,
    required this.ubicacion,
    required this.categoria,
    required this.maxVoluntarios,
    required this.duracion,
    this.imageUrl,
    this.voluntarios = const [],
    required this.asistencia,
    this.feedback = const [],
  });

Map<String, dynamic> toMap() {
  return {
    'titulo': titulo,
    'descripcion': descripcion,
    'fechahora': fechahora,
    'ubicacion': ubicacion,
    'categoria': categoria,
    'maxVoluntarios': maxVoluntarios,
    'imageUrl': imageUrl,
    'voluntarios': voluntarios,
    'duracion': duracion,
    'asistencia': asistencia,
    'feedback': feedback
  };
}


  factory Activity.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate;
    try {
      if (map['fechahora'] is Timestamp) {
        parsedDate = (map['fechahora'] as Timestamp).toDate();
      } else {
        parsedDate = DateTime.parse(map['fechahora']);
      }
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return Activity(
      id: id,
      titulo: map['titulo'] ?? 'Sin título',
      descripcion: map['descripcion'] ?? 'Sin descripción',
      fechahora: parsedDate,
      ubicacion: map['ubicacion'] ?? const GeoPoint(0, 0),
      categoria: map['categoria'] ?? 'Categoría no disponible',
      maxVoluntarios: map['maxVoluntarios'] ?? 0,
      imageUrl: map['imageUrl'],
      voluntarios: map['voluntarios'] ?? [],
      duracion: map['duracion']?? 0,
      asistencia: Map<String, String>.from(map['asistencia'] ?? {}),
      feedback: map['feedback'] ?? [],
    );
  }
}
