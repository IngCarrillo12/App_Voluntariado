import 'package:flutter/material.dart';
import 'package:frontend_flutter/pages/ActivitiesFilterPage.dart';
import 'package:frontend_flutter/pages/AllActivitiesPage.dart';
import 'package:frontend_flutter/pages/ActivityDetailPage.dart';
import 'package:frontend_flutter/pages/CreateOrEditActivityPage.dart';
import 'package:frontend_flutter/Widgets/LocationMap.dart';
import 'package:frontend_flutter/models/activitiesModel.dart';
import 'package:frontend_flutter/pages/ActivitiesByUsers.dart';
import 'package:frontend_flutter/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/pages/Home.dart';
import 'package:frontend_flutter/pages/Login.dart';
import 'package:frontend_flutter/pages/Profile.dart';
import 'package:frontend_flutter/pages/Register.dart';
import 'package:frontend_flutter/services/authService.dart';
import 'package:frontend_flutter/providers/activitiesProvider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verificar si hay sesión iniciada
  bool isLoggedIn = await AuthService().isUserLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUserInfo(context)),
        ChangeNotifierProvider(create: (_) => ActivitiesProvider()..loadActivities()),
      ],
      child: MaterialApp(
        title: 'Volunteer App',
        theme: ThemeData(primarySwatch: Colors.pink),
        initialRoute: isLoggedIn ? '/home' : '/login',
        routes: {
          '/login': (context) => const Login(),
          '/home': (context) => const Home(),
          '/register': (context) => const Register(),
          '/profile': (context) => const Profile(),
          '/activitiesPage': (context) => const AllActivitiesPage(),
          '/createOrEditActivity': (context) => const CreateOrEditActivityPage(),
           '/activityDetailPage': (context) {
            final activityId = ModalRoute.of(context)!.settings.arguments as String;
            return ActivityDetailPage(activityId: activityId);
            },
             '/createOrEditActivityPage': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Activity?;
          return CreateOrEditActivityPage(activity: args);
            },
            '/activitiesFilterPage': (context) {
              final arguments = ModalRoute.of(context)!.settings.arguments as List<Activity>;
              return ActivitiesFilterPage(activities: arguments);
            },
          '/userActivitiesPage': (context) => const UserActivitiesPage(),

          

            
        },
      ),
    );
  }
}
