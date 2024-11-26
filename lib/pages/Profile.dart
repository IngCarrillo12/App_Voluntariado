import 'package:flutter/material.dart';
import 'package:frontend_flutter/Widgets/Button/ElevatedButton.dart';
import 'package:frontend_flutter/Widgets/Cards/ActivityCard.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/Widgets/Navigation/BottomNavigationBar.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);
    final activities = activitiesProvider.activities;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Filtrar actividades asociadas al usuario
    final activitiesByUser = activities.where((activity) {
      return user?.historialParticipacion.contains(activity.id) ?? false;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/profile_background.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const Positioned(
                    top: 100,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_picture.jpg'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Mostrar información del usuario
              Text(
                user?.nombreCompleto ?? "Nombre no disponible",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user?.correo ?? "Correo no disponible",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Rol: ${user?.rol ?? "Rol no disponible"}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                widthFactor: 300.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Horas acumuladas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                      Text("${user?.horasAcumuladas}")
                    ],  
                  ),
                  Column(
                    children: [
                      const Text('Actividades realizadas',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                      Text("${user?.actividadesRealizadas}")
                    ],
                  ),
                ],
              ),
              ),
              const SizedBox(height: 16),
              
              // Edit Profile Button
              Button(
                text: 'Edit Profile',
                onPressed: () {},
                width: 180.0,
              ),
              const SizedBox(height: 10.0),
              Button(
                text: 'Cerrar sesión',
                onPressed: () async {
                  await userProvider.signOut(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                width: 150.0,
                paddingH: 5,
                paddingV: 5,
              ),
              const SizedBox(height: 16),

              // About Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sobre mi",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user?.sobreMi ?? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // TabBar
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.pinkAccent,
                      labelColor: Colors.pinkAccent,
                      unselectedLabelColor: Colors.grey,
                      tabs: [

                        Tab(text:user?.rol == 'voluntario'? "Historial actividades": "Actividades")
                        
                      ],
                    ),
                    const SizedBox(height: 16),

                    // TabBar View
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        children: [
                          user?.rol == 'voluntario'?
                          activitiesByUser.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: activitiesByUser.length,
                                  itemBuilder: (context, index) {
                                    final activity = activitiesByUser[index];
                                    return ActivityCard(
                                      imageUrl: activity.imageUrl ??
                                          "https://via.placeholder.com/150",
                                      title: activity.titulo,
                                      location: activity.ubicacion,
                                      activityId: activity.id,
                                      button: false,
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    "No scheduled activities",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                                :
                                 ListView.builder(
                                  itemCount: activities.length,
                                  itemBuilder: (context, index) {
                                    final activity = activities[index];
                                    return ActivityCard(
                                      imageUrl: activity.imageUrl ??
                                          "https://via.placeholder.com/150",
                                      title: activity.titulo,
                                      location: activity.ubicacion,
                                      activityId: activity.id,
                                      button: false,
                                    );
                                  },
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
