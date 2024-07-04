import 'package:flutter/material.dart';
import 'package:Todo_list_App/Screens/MenuDrawer/DrawerState.dart';
import 'package:provider/provider.dart';
import 'data/shared/Task_saved.dart';
import 'data/themes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await TaskerPreference.init(); // for initialization of SharedPreference..
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
        return MaterialApp(
          title: 'Todo List App',
          debugShowCheckedModeBanner: false,
          themeMode: themProvider.themeMode,
          darkTheme: myTheme.lightTheme,
          theme: myTheme.lightTheme,
          home: const DrawerState(),
        );
      });
}

