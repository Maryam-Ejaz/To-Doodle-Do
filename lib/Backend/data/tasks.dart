import 'package:flutter/material.dart';

class Task {
  String taskNumber;
  String title;
  Color progressColor;
  double value;

  Task({
    required this.taskNumber,
    required this.title,
    required this.progressColor,
    required this.value
  });
}

List<Task> tasklist = [
  Task(taskNumber: "40 tasks", title: "Work", progressColor: const Color(0xFFAC05FF), value: 0.5),
  Task(taskNumber: "16 tasks", title: "Hobbies", progressColor:  Colors.blue, value: 0.1),
  Task(taskNumber: "10 tasks", title: "House Chores", progressColor: Colors.green, value: 0.1),
  Task(taskNumber: "2 tasks", title: "Sports", progressColor: Colors.red, value: 0.1),
  Task(taskNumber: "30 tasks", title: "Family", progressColor: Colors.orange, value: 0.8),


];
