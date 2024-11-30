import 'package:flutter/material.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:provider/provider.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  void resetNavigation() {
    selectedIndexNotifier.value = 0;
  }

  Future<void> onItemTapped(BuildContext context, int index, String rol) async {
    if (selectedIndexNotifier.value == index) return; 
    selectedIndexNotifier.value = index;

    if (rol == 'organizador') {
      switch (index) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          break;
        case 1:
          final result = await Navigator.pushNamed(context, '/createOrEditActivity');
          if (result == true) {
            Provider.of<ActivitiesProvider>(context, listen: false).loadActivities();
          }
          selectedIndexNotifier.value = 0; 
          break;
        case 2:
          Navigator.pushNamedAndRemoveUntil(context, '/userActivitiesPage', (route) => false);
          break;
        case 3:
          Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
          break;
        default:
          break;
      }
    } else {
      switch (index) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          break;
        case 1:
          Navigator.pushNamedAndRemoveUntil(context, '/userActivitiesPage', (route) => false);
          break;
        case 2:
          Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
          break;
        default:
          break;
      }
    }
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final NavigationService navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final rol = user?.rol;

    final navigationItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
      if (rol == 'organizador')
        const BottomNavigationBarItem(icon: Icon(Icons.create), label: "Crear actividad"),
      const BottomNavigationBarItem(icon: Icon(Icons.event), label: " Actividades"),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: navigationService.selectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        final validIndex = (selectedIndex >= 0 && selectedIndex < navigationItems.length)
            ? selectedIndex
            : 0; 

        return BottomNavigationBar(
          currentIndex: validIndex,
          onTap: (index) => navigationService.onItemTapped(context, index, rol ?? ''),
          items: navigationItems,
          selectedItemColor: Colors.pinkAccent,
          unselectedItemColor: Colors.grey,
        );
      },
    );
  }
}


