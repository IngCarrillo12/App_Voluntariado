import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String comentario;
  final int calificacion;
  final DateTime timestamp;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.comentario,
    required this.calificacion,
    required this.timestamp,
  });

  factory FeedbackModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FeedbackModel(
      id: id,
      userId: data['userId'],
      comentario: data['comentario'],
      calificacion: data['calificacion'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'comentario': comentario,
      'calificacion': calificacion,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
