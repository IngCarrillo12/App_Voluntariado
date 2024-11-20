import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend_flutter/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método de inicio de sesión
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Guardar solo el user_id en local
      await _saveUserIdToLocal(userCredential.user);

      return userCredential.user;
    } catch (e) {
      print("Error en el inicio de sesión: ${e.toString()}");
      return null;
    }
  }

  // Método de registro de usuario
  Future<User?> register(
      String email, String password, String nombre, String telefono, String rol) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          userId: user.uid,
          nombreCompleto: nombre,
          correo: email,
          telefono: telefono,
          rol: rol,
          horasAcumuladas: 0,
          actividadesRealizadas: 0,
          historialParticipacion: [],
          sobreMi: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        );

        await db.collection('users').doc(user.uid).set(newUser.toFirestore());

        await _saveUserIdToLocal(user);
      }
      return user;
    } catch (e) {
      print("Error en el registro: ${e.toString()}");
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    await _clearLocalUserData();
  }

  // Método para guardar solo el user_id en local
  Future<void> _saveUserIdToLocal(User? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.uid);
    }
  }

  // Método para limpiar solo el user_id al cerrar sesión
  Future<void> _clearLocalUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  // Método para verificar si hay sesión iniciada
  Future<bool> isUserLoggedIn() async {
    User? currentUser = _auth.currentUser;
    final prefs = await SharedPreferences.getInstance();
    return currentUser != null && prefs.containsKey('user_id');
  }

  // Método para obtener información del usuario usando el user_id de SharedPreferences
  Future<UserModel?> getUserInfoById() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      try {
        DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
        } else {
          print("No user found with the given user_id.");
          return null;
        }
      } catch (e) {
        print("Error fetching user info: $e");
        return null;
      }
    } else {
      print("User ID not found in SharedPreferences.");
      return null;
    }
  }

   Future<void> addActivityToHistory(String userId, String activityId) async {
    try {
      await db.collection('users').doc(userId).update({
        'historial_participacion': FieldValue.arrayUnion([activityId]),
      });
    } catch (e) {
      print("Error al añadir actividad al historial del usuario: $e");
    }
  }
  
  Future<void> removeActivityFromHistory(String userId, String activityId) async {
  try {
    await db.collection('users').doc(userId).update({
      'historial_participacion': FieldValue.arrayRemove([activityId]),
    });
  } catch (e) {
    print("Error al eliminar actividad del historial del usuario: $e");
  }
}

Future<void> updateUserStatistics(String userId, int newHoras, int newActividades) async {
  try {
    await db.collection('users').doc(userId).update({
      'horas_acumuladas': newHoras,
      'actividades_realizadas': newActividades,
    });
  } catch (e) {
    print("Error al actualizar estadísticas en Firestore: $e");
  }
}


}
