import 'package:Todo_list_App/Backend/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../Backend/Animation/fadeAnimation.dart';
import '../../Backend/data/enums/task_filter.dart';
import '../../Backend/data/enums/task_sorting.dart';
import '../../Backend/data/services/notification_services.dart';
import '../../Backend/data/shared/Task_saved.dart';
import '../../Backend/data/tasks.dart';
import '../../Backend/Animation/linearprogress.dart';
import '../../Backend/data/time_say.dart';
import '../TaskScreens/add_task_screen.dart';
import '../custom_widgets/add_category_widget.dart';
import '../custom_widgets/custom_snackbars.dart';
import '../custom_widgets/delete_dialog.dart';
import '../custom_widgets/setting_bottom_sheet.dart';
import 'package:Todo_list_App/Backend/providers/task_provider.dart';
import '../custom_widgets/task_block.dart';
import 'package:Todo_list_App/Backend/data/colors.dart';


class MyHomePage extends StatefulWidget {
  VoidCallback openDrawer;
  MyHomePage({required this.openDrawer});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationServices notificationServices = NotificationServices();
  Offset initialPosition = Offset(0, 0);
  Offset currentPosition = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var we = MediaQuery.of(context).size.width;
      var he = MediaQuery.of(context).size.height;
      setState(() {
        initialPosition = Offset(we - 60, he - 60);
        currentPosition = initialPosition;
      });
    });
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      print('Device token');
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    // Provider.of<TaskProvider>(context, listen:false).fetchCategories_();
    // Provider.of<TaskProvider>(context, listen:false).fetchTasks();



    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {

      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backGroundColor,
          actions: [
            Row(
              //crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: widget.openDrawer,
                    icon: const Icon(
                      Icons.drag_handle_rounded,
                      // color: Color(0xffc4afcd),
                      size: 35,
                    )),
                SizedBox(
                  width: we * 0.8, // 0.07  0.73
                ),
                SizedBox(
                  width: we * 0.03,
                ),
                SizedBox(
                  width: we * 0.02, // 0.07
                ),
                //ChangeThembutton()
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: SizedBox(
            //width: we-20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeAnimation(
                  delay: 0.8,
                  child: Container(
                    margin: EdgeInsets.only(top: he * 0.02, left: 18),
                    width: we * 0.9,
                    height: he * 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Timecall(),
                        SizedBox(
                          height: he * 0.06,
                        ),
                        Text(
                          "CATEGORIES",
                          style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.grey.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FadeAnimation(
                  delay: 1,
                  child: SizedBox(
                    width: we * 2,
                    height: he * 0.16,
                    child: taskProvider.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        if (i < taskProvider.taskList.length) {
                          return GestureDetector(
                            onTap: () {
                              taskProvider.updateFilter(TaskFilter.all, taskProvider.taskList[i].title);
                            },
                            child: Card(
                              color: Color(0xEAFFFFFF),
                              margin: EdgeInsets.only(left: 23),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              clipBehavior: Clip.antiAlias,
                              elevation: 10,
                              shadowColor: Colors.black.withOpacity(0.2),
                              child: Container(
                                width: we * 0.5,
                                height: he * 0.5,
                                margin: EdgeInsets.only(
                                  top: 10,
                                  left: 16,
                                  right: 5,
                                  bottom: 10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${taskProvider.taskList[i].taskNumber.toString()} tasks",
                                                style: TextStyle(
                                                  color: Colors.grey.withOpacity(0.9),
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.redAccent.withOpacity(0.6),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text('Confirm Delete'),
                                                      content: Text(
                                                          'Are you sure you want to delete this category?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            taskProvider.deleteCategory(
                                                                taskProvider.taskList[i].title);
                                                          },
                                                          child: Text('Delete'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: he * 0.0001,
                                          ),
                                          Text(
                                            taskProvider.taskList[i].title,
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: he * 0.02),
                                          Padding(
                                            padding: EdgeInsets.only(right: 30),
                                            child: LineProgress(
                                              value: taskProvider.taskList[i].value.toDouble(),
                                              Color: taskProvider.taskList[i].progressColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (i == taskProvider.taskList.length) {
                          return GestureDetector(
                            onTap: () {
                              AddCategoryDialog.showAddCategoryDialog(context);
                            },
                            child: Card(
                              color: Color(0xEAFFFFFF),
                              margin: EdgeInsets.only(left: 23),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              clipBehavior: Clip.antiAlias,
                              elevation: 10,
                              shadowColor: Colors.black.withOpacity(0.2),
                              child: Container(
                                width: we * 0.5,
                                height: he * 0.1,
                                margin: EdgeInsets.only(
                                  top: 30,
                                  bottom: 30,
                                  left: 11,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white10,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 48,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                      itemCount: taskProvider.taskList.length + 1,
                    ),
                  ),
                ),

                FadeAnimation(
                  delay: 0.8,
                  child: Container(
                    margin: EdgeInsets.only(top: he * 0.02, left: 18),
                    width: we * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TASKS",
                          style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.grey.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: he * 0.01),
                FadeAnimation(
                  delay: 0.8,
                  child: Row(
                    children: [
                      DropdownButton<TaskFilter>(
                        padding: EdgeInsets.only(left: 20),
                        hint: Text("Filter"),
                        onChanged: (TaskFilter? newValue) {
                          if (newValue != null) {
                            taskProvider.updateFilter(newValue, '');
                            taskProvider.updateSortOption(TaskSortOption.none);
                          }
                        },
                        items: TaskFilter.values
                            .map((TaskFilter filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(
                            filter == TaskFilter.all
                                ? 'All Tasks'
                                : filter == TaskFilter.done
                                ? 'Done'
                                : 'Pending',
                          ),
                        ))
                            .toList(),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      DropdownButton<TaskSortOption>(
                        padding: EdgeInsets.only(right: 20),
                        hint: Text("Sort"),
                        onChanged: (TaskSortOption? newValue) {
                          if (newValue != null) {
                            taskProvider.updateSortOption(newValue);
                            taskProvider.updateFilter(TaskFilter.all, '');
                          }
                        },
                        items: TaskSortOption.values
                            .map((TaskSortOption filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(
                            filter == TaskSortOption.none
                                ? 'None'
                                : filter == TaskSortOption.dueDate
                                ? 'Due date'
                                : 'Create Date',
                          ),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: taskProvider.taskStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final tasks = snapshot.data;

                      if (taskProvider.taskStream == null) {
                        return Center(
                          child: Text(
                            "No tasks available",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tasks?.length,
                        itemBuilder: (context, index) {
                          final task = tasks![index];
                          return Dismissible(
                            key: Key(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Colors.redAccent,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) async {
                              taskProvider.deleteTask(task.id);
                              CustomSnackBar.showSuccess(
                                  'Task Deleted Successfully');
                            },
                            child: TaskBlock(
                              title: task.title,
                              description: task.description,
                              onDelete: () async {
                                final confirmed = await CustomDialog
                                    .showDeleteConfirmationDialog(context);
                                if (confirmed != null && confirmed) {
                                  taskProvider.deleteTask(task.id);
                                  CustomSnackBar.showSuccess(
                                      'Task Deleted Successfully');
                                }
                              },
                              done: task.done,
                              onDone: () {
                                taskProvider.updateTaskStatus(
                                    task.id, !task.done, context);
                              },
                              dueDate: task.dueDate,
                              createDate: task.createDate,
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              left: currentPosition.dx,
              top: currentPosition.dy,
              child: Draggable(
                feedback: const Material(
                  type: MaterialType.transparency,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: FloatingActionButton(
                      onPressed: null,
                      backgroundColor: kPrimaryColor,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(),
                onDraggableCanceled: (velocity, offset) {
                  setState(() {
                    // Ensure FAB stays within screen bounds
                    // Ensure FAB stays within screen bounds
                    double newX = offset.dx.clamp(0.0, we - 60); // Clamp horizontally
                    double newY = offset.dy.clamp(
                      MediaQuery.of(context).padding.top + kToolbarHeight,
                      he - 60,
                    ); // Clamp vertically

                    currentPosition = Offset(newX, newY);
                  });
                },
                child: FloatingActionButton(
                  onPressed: () async {
                    Get.to(() => const AddTaskScreen());
                  },
                  backgroundColor: kPrimaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),


      );
    });
  }
}
