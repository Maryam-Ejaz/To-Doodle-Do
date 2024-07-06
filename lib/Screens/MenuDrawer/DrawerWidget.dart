import 'package:Todo_list_App/Backend/data/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Backend/providers/task_provider.dart';
import '../Other Screens/Avatar_progerss.dart';
import '../Other Screens/chart.dart';
import 'DrawerItems.dart';

class DrawerWidget extends StatefulWidget {
  VoidCallback closedDrawer;
  DrawerWidget({Key? key, required this.closedDrawer}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  final double runAnim = 0.4;
  late String? userName;

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: Column(
      children: [
        buildDrawerCloseButton(context),
        Progerss_Avater(),
        SizedBox(
          height: he * 0.02,
        ),
        //buildText(context),
        SizedBox(
          height: he * 0.08,
        ),
        buildDrawerItem(context),
        SizedBox(
          height: he * 0.02,
        ),
        //Chart()
      ],
    ));
  }

  Widget buildDrawerItem(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: DrawerItems.all
              .map((item) {
            VoidCallback? onTap;

            // Define specific actions for each drawer item
            switch (item.title) {
              case "Categories":
                onTap = () {
                  // Navigate to Categories screen

                };
                break;
              case "Analytics":
                onTap = () {
                  // Navigate to Analytics screen

                };
                break;
              case "About":
                onTap = () {
                  // Navigate to About screen

                };
                break;
              case "Logout":
                onTap = () {
                  // Handle Logout
                  taskProvider.logout();
                  Get.back();
                };
                break;
            }

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 3),
              leading: Icon(
                item.icon,
                color: Colors.white.withOpacity(0.5),
              ),
              title: Text(
                item.title,
                style: GoogleFonts.play(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              onTap: onTap,
            );
          }).toList(),
        ),
      );
    });
  }

    Widget buildDrawerCloseButton(context) {
      var we = MediaQuery.of(context).size.width;
      var he = MediaQuery.of(context).size.height;

      return Container(
        margin: EdgeInsets.only(top: he * 0.09, left: we * 0.15),
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration:
        const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        child: Container(
            width: 47,
            height: 47,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kDrawerColor,
            ),
            child: IconButton(
                onPressed: widget.closedDrawer,
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                  size: 20,
                ))),
      );
    }

    Widget buildText(context) {
      var we = MediaQuery.of(context).size.width;
      var he = MediaQuery.of(context).size.height;

      return Consumer<TaskProvider>(builder: (context, taskProvider, child)
      {
        return Container(
          margin: EdgeInsets.only(right: we * 0.4),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Text(
          "{$userName}",
          style: GoogleFonts.lato(
              fontSize: 40,
              letterSpacing: 2,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      Text(
      "Deep",
      style: GoogleFonts.lato(
      fontSize: 40,
      letterSpacing: 2,
      color: Colors.white,
      fontWeight: FontWeight.bold),
      ),
      ],
      ),
      );
    });
    }
  }

