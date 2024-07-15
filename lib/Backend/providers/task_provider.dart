import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Todo_list_App/Backend/data/enums/task_sorting.dart';
import 'package:Todo_list_App/Screens/Other Screens/Authentication/login_screen.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_snackbars.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/tasks.dart';
import '../model/task_model.dart';
import 'package:Todo_list_App/Backend/model/dailyTaskData.dart';
import '../data/enums/task_filter.dart';
import '../data/services/local_notification.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Task> tasks = [];

  String? username;
  String? userEmail;
  late Stream<List<Task>> _taskStream = Stream.empty();
  Stream<List<Task>> get taskStream => _taskStream;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _categoryStream = []; // categories in add task screen
  List<String> get categories => _categoryStream;

  TaskFilter currentFilter = TaskFilter.all;
  TaskSortOption currentOption = TaskSortOption.none;
  String? categorySort = '';

  Map<String, int> _taskCountPerCategory = {};
  List<Task_> _taskList = [];

  List<Task_> get taskList => _taskList;

  DateTime? selectedDueDate;

  TaskProvider() {
    print("Started Task Provider");
  }

  Future<void> initialize() async {
    user = FirebaseAuth.instance.currentUser; // Reassign user
    print("Initializing Task Provider");
    // await getUserName();
    // await fetchTasks();
    // await fetchCategories();
  }

  Future<void> addTask(String title, String description, String category,
      BuildContext context) async {
    ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      if (_auth.currentUser?.uid == null) {
        throw Exception('User is not authenticated');
      }

      dialog.show();
      await _firestore.collection('tasks').add({
        'title': title,
        'description': description ?? '',
        'category': category,
        'uid': _auth.currentUser?.uid,
        'done': false,
        'created_at': DateTime.now(),
        'due': selectedDueDate ?? DateTime.now(),
      });
      DateTime taskAddedTime = DateTime.now();
      DateTime notificationTime = taskAddedTime.add(const Duration(minutes: 1));

      await LocalNotificationService().scheduleNotification(
        id: 1,
        title: 'Task Reminder',
        body: 'Don\'t forget to complete your task: Alfred Local Notification',
        scheduledNotificationDateTime: selectedDueDate ?? DateTime.now(),
      );

      await fetchTasks();
      await fetchCategories();
      notifyListeners();
      dialog.dismiss();
      Get.back();
      CustomSnackBar.showSuccess('Task Added Successfully');
    } catch (e) {
      CustomSnackBar.showError('Error adding task: $e');
      dialog.dismiss();
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      await fetchTasks();
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  void updateTaskStatus(String taskId, bool newStatus, context) async {
    ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Updating Status'));
    dialog.show();
    _firestore
        .collection('tasks')
        .doc(taskId)
        .update({'done': newStatus}).then((value) async {
      print('Task status updated successfully');
      await fetchCategories();
      notifyListeners();
      dialog.dismiss();
    }).catchError((error) {
      dialog.dismiss();
      print('Failed to update task status: $error');
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final initialDate = selectedDueDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedDueDate = pickedDate;
      notifyListeners();
    }
  }

  Future<void> getUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final name = data['name'];
          print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
          print(name);
          username = name;
          userEmail = _auth.currentUser?.email.toString();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error getting user name: $e');
      rethrow;
    }
  }

  Future<void> updateUserData(username_) async {
    print("ccccccccccccccccc");
    print(username_);
    final userCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = userCollection.doc(_auth.currentUser?.uid);

    await userDoc.update({'name': username_}).then((_) async {
      CustomSnackBar.showSuccess('Profile Update Successfully');
      await getUserName();
    }).catchError((error) {
      CustomSnackBar.showError('Error updating user data: $error');
    });
  }

  Future<void> fetchTasks() async {
    Query query = _firestore.collection('tasks');
    print('>>>>>>>>>>>>>>>>>>');
    print(TaskFilter);
    final currentUserUid = _auth.currentUser?.uid;
    print(currentUserUid);
    print(categorySort);
    if (currentUserUid != null) {
      query = query.where('uid', isEqualTo: currentUserUid);
    } else {
      return;
    }
    if (currentFilter == TaskFilter.done && categorySort == '') {
      query = _firestore
          .collection('tasks')
          .where('done', isEqualTo: true)
          .where('uid', isEqualTo: currentUserUid);
    } else if (currentFilter == TaskFilter.pending && categorySort == '') {
      query = _firestore
          .collection('tasks')
          .where('done', isEqualTo: false)
          .where('uid', isEqualTo: currentUserUid);

    } else if (currentFilter == TaskFilter.all && categorySort != '') {
      print(categorySort);
      print(currentFilter);
      query = _firestore
          .collection('tasks')
          .where('uid', isEqualTo: currentUserUid)
          .where('category', isEqualTo: categorySort);
      categorySort = '';
    } else {
      query = _firestore
          .collection('tasks')
          .where('uid', isEqualTo: currentUserUid);
    }


    if (currentOption == TaskSortOption.dueDate) {
      query = _firestore
          .collection('tasks')
          .where('uid', isEqualTo: currentUserUid)
          .orderBy('due', descending: true);
    } else if (currentOption == TaskSortOption.creationDate) {
      query = _firestore
          .collection('tasks')
          .where('uid', isEqualTo: currentUserUid)
          .orderBy('created_at', descending: true);
    }

    _taskStream = query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList());
    //notifyListeners();
  }

  void updateFilter(TaskFilter newFilter, String? categoryString) {

    if (categoryString != '')
    {
      print("updateFilter");
      categorySort = categoryString;
      currentFilter = newFilter;
      fetchTasks();
      notifyListeners();
    }

    else  {
      print("Update filter");
      currentFilter = newFilter;
      categorySort = '';
      fetchTasks();
      notifyListeners();
    }


  }

  void updateSortOption(TaskSortOption sortOption) {
    if (currentOption != sortOption) {
      currentOption = sortOption;
      fetchTasks();
      notifyListeners();
    }
  }

  Future<void> fetchCategories_() async {
    if (_auth.currentUser == null) return;
    await fetchCategories();
    notifyListeners();
  }

  // Function to fetch categories for the active user
  Future<void> fetchCategories() async {
    if (_auth.currentUser == null) return;

    try {
      _isLoading = true;
      QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      _categoryStream = [];
      _categoryStream = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] as String;
      }).toList();

      _taskList.clear();

      for (var category in _categoryStream) {
        int taskCount = await _fetchTaskCount(category);
        int completedTasks = await _fetchCompletedTaskCount(category);
        Color randomColor = _getRandomColor();
        double progress = taskCount > 0 ? completedTasks / taskCount : 0.0;

        print(category);

        _taskList.add(Task_(
          taskNumber: "$taskCount",
          title: category,
          progressColor: randomColor,
          value: progress,
        ));
      }
      _isLoading = false;
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<int> _fetchTaskCount(String category) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('category', isEqualTo: category)
        .where('uid', isEqualTo: _auth.currentUser?.uid)
        .get();
    return snapshot.docs.length;
  }

  Future<int> _fetchCompletedTaskCount(String category) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('category', isEqualTo: category)
        .where('uid', isEqualTo: _auth.currentUser?.uid)
        .where('done', isEqualTo: true)
        .get();
    return snapshot.docs.length;
  }

  Color _getRandomColor() {
    // List of available colors from Task_ class
    List<Color> colors = [
      const Color(0xFFAC05FF),
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      // Add more colors if needed
    ];
    // Generate a random index
    int randomIndex = Random().nextInt(colors.length);
    // Return the color at the random index
    return colors[randomIndex];
  }

  Future<void> addCategory(String category, context) async {
    if (user == null) return;
    ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .where('uid', isEqualTo: user!.uid)
          .get();

      // Check if the number of categories is 6 or more
      if (snapshot.docs.length >= 6) {
        // Show a snackbar
        dialog.dismiss();
        Get.back();
        CustomSnackBar.showError('Only 5 categories can be added.');
        return;
      }

      // Check if the category name already exists
      bool categoryExists = snapshot.docs.any((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] == category;
      });

      if (categoryExists) {
        dialog.dismiss();
        Get.back();
        // Show a snackbar
        CustomSnackBar.showError('Category name already exists.');
        return;
      }

      await _firestore.collection('categories').add({
        'name': category,
        'uid': user!.uid,
      });
      dialog.dismiss();
      Get.back();
      CustomSnackBar.showSuccess('Category Added Successfully');
      await fetchCategories();
      notifyListeners();
    } catch (e) {
      dialog.dismiss();
      Get.back();
      print('Error adding category: $e');
    }
  }

  Future<void> deleteCategory(String category) async {
    if (user == null) return;

    if (category.toLowerCase() == 'work') {
      Get.back();
      CustomSnackBar.showError('Error: Cannot delete default category.');
      return;
    }

    try {
      // Fetch tasks with the category to be deleted
      QuerySnapshot taskSnapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: _auth.currentUser?.uid)
          .where('category', isEqualTo: category)
          .get();

      // Reassign tasks to "Work"
      for (var taskDoc in taskSnapshot.docs) {
        await taskDoc.reference.update({'category': 'Work'});
      }

      // Fetch the category to be deleted
      QuerySnapshot categorySnapshot = await _firestore
          .collection('categories')
          .where('uid', isEqualTo: _auth.currentUser?.uid)
          .where('name', isEqualTo: category)
          .get();

      // Delete the category
      for (var doc in categorySnapshot.docs) {
        await doc.reference.delete();
      }

      if (taskSnapshot.docs.isNotEmpty) {
        Get.back();
        CustomSnackBar.showSuccess(
            'Category deleted and tasks reassigned to "Work" successfully.');
      } else {
        Get.back();
        CustomSnackBar.showSuccess('Category deleted successfully.');
      }

      await fetchCategories();
      notifyListeners(); // Refresh the categories list
    } catch (e) {
      Get.back();
      CustomSnackBar.showError('Error deleting category: $e');
      print('Error deleting category: $e');
    }
  }

  Future<List<DailyTaskData>> getWeeklyTaskData() async {
    List<Color> chartColors = [
      Color(0xFF2196F3),
      Color(0xFFFFC300),
      Color(0xFFFF683B),
      Color(0xFF3BFF49),
      Color(0xFF6E1BFF),
      Color(0xFFFF3AF2),
      Color(0xFFE80054),
      Color(0xFF50E4FF),
    ];
    int i = 0;
    List<DailyTaskData> weeklyData = [];
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Iterate through each day of the week
    for (DateTime day = startOfWeek;
        day.isBefore(endOfWeek);
        day = day.add(const Duration(days: 1))) {
      print(day);
      int totalTasks = await _getTotalTasksForDay(day);
      int completedTasks = await _getCompletedTasksForDay(day);

      // Create DailyTaskData object and add to weeklyData list
      DailyTaskData dailyData = DailyTaskData(
          day: DateTime(day.year, day.month, day.day), // Date without time
          totalTasks: totalTasks,
          completedTasks: completedTasks,
          colour: chartColors[i]);
      weeklyData.add(dailyData);
      i = i + 1;
    }

    return weeklyData;
  }

  Future<int> _getTotalTasksForDay(DateTime day) async {
    DateTime startOfDay = DateTime(day.year, day.month, day.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    QuerySnapshot querySnapshot = await _firestore
        .collection('tasks')
        .where('uid', isEqualTo: _auth.currentUser?.uid.toString())
        .where('created_at', isGreaterThanOrEqualTo: startOfDay)
        .where('created_at', isLessThan: endOfDay)
        .get();

    return querySnapshot.docs.length; // Return total tasks count
  }

  Future<int> _getCompletedTasksForDay(DateTime day) async {
    DateTime startOfDay = DateTime(day.year, day.month, day.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));
    QuerySnapshot querySnapshot = await _firestore
        .collection('tasks')
        .where('uid',
            isEqualTo: _auth.currentUser?.uid
                .toString()) // Adjust to your user identification logic
        .where('created_at', isGreaterThanOrEqualTo: startOfDay)
        .where('created_at', isLessThan: endOfDay)
        .where('done', isEqualTo: true)
        .get();

    return querySnapshot.docs.length; // Return completed tasks count
  }
}
