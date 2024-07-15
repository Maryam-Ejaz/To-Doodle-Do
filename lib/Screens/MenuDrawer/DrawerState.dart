import 'package:Todo_list_App/Backend/data/colors.dart';
import 'package:flutter/material.dart';
import '../Other Screens/homepage.dart';
import 'DrawerWidget.dart';
import 'package:flutter/services.dart';

class DrawerState extends StatefulWidget {
  const DrawerState({Key? key}) : super(key: key);

  @override
  State<DrawerState> createState() => _DrawerState();
}

class _DrawerState extends State<DrawerState> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawingOpen;
  bool isDragging = false;
  Widget? currentPage;

  void openDrawer() {
    setState(() {
      xOffset = 300;
      yOffset = 70;
      scaleFactor = 0.85;
      isDrawingOpen = true;
    });

  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawingOpen = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    closeDrawer();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: kDrawerColor,
      body: Stack(children: [
        DrawerWidget(
          closedDrawer: closeDrawer,
        ),
        buildPage()
      ]));

  Widget buildPage() {
    return GestureDetector(
      onHorizontalDragStart: (details) => isDragging = true,
      onHorizontalDragUpdate: (details) {
        if (!isDragging) return;
        const delta = 1;
        if (details.delta.dx > delta) {
          openDrawer();
        } else if (details.delta.dx < -delta) {
          closeDrawer();
        }
      },
      onTap: closeDrawer,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawingOpen ? 30 : 0),
            child: MyHomePage(
              openDrawer: openDrawer,
            ),
          )),
    );
  }

// Method to set the current page based on a parameter
// void setPage(String pageName) {
//   setState(() {
//     if (pageName == 'HomePage') {
//       currentPage = MyHomePage(openDrawer: openDrawer);
//     } else if (pageName == 'AnalyticsPage') {
//       currentPage = AnalyticsPage();
//     }
//     // Add more conditions for other pages as needed
//   });
// }


}
