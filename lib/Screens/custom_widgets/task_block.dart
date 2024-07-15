import 'package:Todo_list_App/Backend/data/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:Todo_list_App/Backend/data/themes.dart';

class TaskBlock extends StatelessWidget {
  final String title;
  final bool done;
  final Timestamp dueDate;
  final Timestamp createDate;
  final VoidCallback onDelete;
  final VoidCallback onDone;
  final String description;



  TaskBlock(
      {super.key,
      required this.title,
      required this.description,
      required this.onDelete,
      required this.done,
      required this.onDone,
      required this.dueDate,
      required this.createDate});

  final colorIcon = [
    Colors.teal,
    Colors.blue,
    Colors.pinkAccent,
    Colors.purple,
    Colors.indigo
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    int index = random.nextInt(colorIcon.length);
    final color_ = colorIcon[index];
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(15), // Set the border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              SizedBox(
                width: Get.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Create: ${DateFormat('dd-MM-yyyy').format(createDate.toDate()).toString()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Due: ${DateFormat('dd-MM-yyyy').format(dueDate.toDate()).toString()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: onDone,
                    icon: Icon(
                        done ? Icons.check_circle_rounded : Icons.circle_outlined,
                        color: color_,),

                  ),
                  const SizedBox(height: 8),
                  IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
