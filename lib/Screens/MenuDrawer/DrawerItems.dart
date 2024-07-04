import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem({
    required this.title,
    required this.icon,
    required MaterialColor color
  });
}

class DrawerItems {
  static final categories =
      DrawerItem(
          title: "Categories",
          icon: Icons.grid_view_outlined,
          color: Colors.grey);
  static final analytics =
      DrawerItem(title: "Analytics",
          icon: Icons.pie_chart,
          color: Colors.grey);
  static final about =
      DrawerItem(title: "About",
          icon: Icons.person_outlined,
          color: Colors.grey);

  static final List<DrawerItem> all = [categories, analytics, about];
}
