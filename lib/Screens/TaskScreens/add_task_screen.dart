import 'package:flutter/material.dart';
import 'package:Todo_list_App/Backend/data/colors.dart';
import 'package:Todo_list_App/Backend/providers/task_provider.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_buttons.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_snackbars.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  late String selectedCategory; // Default category
  final List<String> categories = [
    'Work',
    'Personal',
    'Other'
  ]; // List of categories

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Task', style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/add.png',
                    height: 200,
                  ),
                ),
                CustomTextField(
                  prefixIcon: const Icon(
                    Icons.title,
                    color: kPrimaryColor,
                  ),
                  controller: titleController,
                  hintText: 'Title',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  prefixIcon: const Icon(
                    Icons.description,
                    color: kPrimaryColor,
                  ),
                  controller: descriptionController,
                  hintText: 'Description...',
                ),
                const SizedBox(height: 15.0),
                // Category Dropdown
                Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  height: 65, // Specify the desired height here
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(15),
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0), // Adjust top padding as needed
                      child: DropdownButtonFormField<String>(
                        dropdownColor: kWhite,
                        icon: const Icon(Icons.arrow_downward, color: kWhite),
                        decoration: const InputDecoration(
                          hintText: "Category",
                          hintStyle: TextStyle(height: 3),
                          prefixIcon: Icon(
                            Icons.category,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: Icon(
                            Icons.arrow_downward,
                            color: kPrimaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                        ),
                        itemHeight: 65, // Adjust the itemHeight to match the container height
                        items: categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                      ),
                  ),
                ),
                //const SizedBox(height: 10.0),
                const SizedBox(height: 15.0),
                CustomTextField(
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: kPrimaryColor,
                  ),
                  controller: TextEditingController(
                      text: taskProvider.selectedDueDate != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(taskProvider.selectedDueDate!)
                          : 'Due Date'),
                  hintText: 'Due Date...',
                  onTap: () {
                    taskProvider.selectDate(context);
                  },
                ),
                const SizedBox(height: 10.0),
                const SizedBox(height: 10.0),
                const SizedBox(height: 40.0),
                MyButtonLong(
                    name: 'Add Task',
                    onTap: () {
                      if (titleController.text.isEmpty) {
                        return CustomSnackBar.showError('Please provide title');
                      }
                      taskProvider.addTask(
                          titleController.text,
                          descriptionController.text,
                          selectedCategory,
                          context);
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
