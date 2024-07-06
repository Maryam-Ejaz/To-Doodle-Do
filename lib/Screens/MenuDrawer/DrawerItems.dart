import 'package:flutter/material.dart';
import 'package:Todo_list_App/Backend/providers/task_provider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DrawerItem {
  String title;
  IconData icon;
  MaterialColor color;
  VoidCallback? onTap;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });
}


class DrawerItems {
  static final categories = DrawerItem(
    title: "Categories",
    icon: Icons.grid_view_outlined,
    color: Colors.grey,
  );

  static final analytics = DrawerItem(
    title: "Analytics",
    icon: Icons.pie_chart,
    color: Colors.grey,
  );

  static final about = DrawerItem(
    title: "About",
    icon: Icons.person_outlined,
    color: Colors.grey,
  );

  static final logout = DrawerItem(
    title: "Logout",
    icon: Icons.logout_outlined,
    color: Colors.grey,
  );

  static final List<DrawerItem> all = [categories, analytics, about, logout];
}
