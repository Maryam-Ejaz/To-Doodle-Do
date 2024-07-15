import 'package:flutter/material.dart';
import 'package:Todo_list_App/Backend/data/colors.dart';
import 'package:Todo_list_App/Backend/providers/task_provider.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_buttons.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_snackbars.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize nameController with the fetched username
    // Initialize nameController with the fetched username
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    nameController.text = taskProvider.username!;
    emailController.text = taskProvider.userEmail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    var userEmail = taskProvider.userEmail;
    var userName = taskProvider.username;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/user.png'),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 55,
              child: CustomTextField(
                readOnly: true,
                prefixIcon: const Icon(Icons.email, color: kPrimaryColor),
                controller: emailController,
                hintText: userEmail.toString(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 55,
              child: CustomTextField(
                prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                controller: nameController,
                hintText: 'Username',
              ),
            ),
            SizedBox(height: 40),
            MyButtonLong(
              name: 'Save',
              onTap: () async {
                String? newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  taskProvider.updateUserData(newName);
                } else {
                  print('Please enter a valid username');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
