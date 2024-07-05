import 'package:flutter/material.dart';
import 'package:Todo_list_App/Screens/MenuDrawer/DrawerState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'FirebaseOptions.dart';
import 'package:provider/provider.dart';
import 'Screens/Authentication/login_screen.dart';
import 'data/shared/Task_saved.dart';
import 'data/themes.dart';
import 'package:Todo_list_App/data/services/local_notification.dart';
import 'package:Todo_list_App/providers/login_provider.dart';
import 'package:Todo_list_App/Screens/TaskScreens/tasks_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Todo_list_App/Screens/introduction_screen.dart';

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
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themProvider = Provider.of<ThemeProvider>(context);
        return GetMaterialApp(
          title: 'Todo List App',
          debugShowCheckedModeBanner: false,
          themeMode: themProvider.themeMode,
          darkTheme: myTheme.lightTheme,
          theme: myTheme.lightTheme,
          initialRoute: initScreen == 0 || initScreen == null ? "/" : "home",
          routes: {
            '/': (context) => const MyIntroductionScreen(),
            'home': (context) => FirebaseAuth.instance.currentUser == null
                ? const LoginScreen()
                : const DrawerState()
          },
          //home: const DrawerState(),
        );
      });
}

