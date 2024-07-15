import 'package:flutter/material.dart';

class DailyTaskData {
  final DateTime day;
  final int totalTasks;
  final int completedTasks;
  final Color colour;

  DailyTaskData({
    required this.day,
    required this.totalTasks,
    required this.completedTasks,
    required this.colour
  });
}