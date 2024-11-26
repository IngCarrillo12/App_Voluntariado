import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_flutter/models/feedbackModel.dart';

class ActivitiesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFeedback(String activityId, FeedbackModel feedback) async {
    try {
      await _firestore
          .collection('activities')
          .doc(activityId)
          .collection('feedback')
          .add(feedback.toFirestore());
      notifyListeners();
    } catch (e) {
      print("Error al agregar feedback: $e");
    }
  }

  Future<List<FeedbackModel>> getFeedback(String activityId) async {
    try {
      final querySnapshot = await _firestore
          .collection('activities')
          .doc(activityId)
          .collection('feedback')
          .get();

      return querySnapshot.docs.map((doc) {
        return FeedbackModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error al obtener feedback: $e");
      return [];
    }
  }
}
