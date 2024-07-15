import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String title;
  final String id;
  final bool done;
  final Timestamp dueDate;
  final Timestamp createDate;
  final String description;
  final String category;

  Task(this.title, this.description, this.id, this.category, this.done, this.dueDate,
      this.createDate);

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        title = snapshot['title'],
        done = snapshot['done'],
        category = snapshot['category'],
        dueDate = snapshot['due'],
        createDate = snapshot['created_at'],
        description = snapshot['description'];
}
