import 'package:flutter/material.dart';
import 'package:Todo_list_App/Screens/MenuDrawer/DrawerState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Backend/providers/signup_provider.dart';
import 'FirebaseOptions.dart';
import 'package:provider/provider.dart';
import 'Screens/Other Screens/Authentication/login_screen.dart';
import 'Backend/data/shared/Task_saved.dart';
import 'package:Todo_list_App/Backend/data/themes.dart';
import 'package:Todo_list_App/Backend/data/services/local_notification.dart';
import 'package:Todo_list_App/Backend/providers/login_provider.dart';
import 'package:Todo_list_App/Backend/providers/task_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Other Screens/introduction_screen.dart';

int? initScreen;
SharedPreferences? prefs;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await TaskerPreference.init(); // for initialization of SharedPreference..
  initScreen = (prefs?.getInt("initScreen"));
  prefs?.setInt("initScreen", 1);
  //LocalNotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GetMaterialApp(
            title: 'Todo List App',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            darkTheme: myTheme.lightTheme,
            theme: myTheme.lightTheme,
            initialRoute: initScreen == 0 || initScreen == null ? "/" : "home",
            routes: {
              '/': (context) => const MyIntroductionScreen(),
              //'home': (context) => const DrawerState()
              'home': (context) => FirebaseAuth.instance.currentUser == null
                  ? const LoginScreen()
                  : const DrawerState()
            },
          );
        },
      ),
    );
  }
}
