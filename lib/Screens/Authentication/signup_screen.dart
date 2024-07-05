import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Todo_list_App/providers/signup_provider.dart';
import 'package:Todo_list_App/Screens/Authentication/login_screen.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_buttons.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_snackbars.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../../data/themes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signupProvider, child) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'Registration',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.black45),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Please register yourself\n to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.person,
                      color:  Color(0xff43025f),
                    ),
                    controller: nameController,
                    hintText: 'Name',
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.alternate_email,
                      color:  Color(0xff43025f),
                    ),
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.lock_open,
                      color:  Color(0xff43025f),
                    ),
                    controller: passController,
                    obscure: !signupProvider.isPasswordVisible,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        signupProvider.togglePasswordVisibility();
                      },
                      icon: Icon(
                        signupProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color:Color(0xff43025f),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.lock_open,
                      color: Color(0xff43025f),
                    ),
                    controller: conPassController,
                    obscure: !signupProvider.isPasswordVisible,
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        signupProvider.togglePasswordVisibility();
                      },
                      icon: Icon(
                        signupProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xff43025f),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  MyButtonLong(
                      name: 'Sign Up',
                      onTap: () {
                        if (emailController.text.isEmpty ||
                            nameController.text.isEmpty ||
                            passController.text.isEmpty) {
                          return CustomSnackBar.showError(
                              'Please fill all the fields');
                        } else {
                          signupProvider.signUpWithEmailAndPassword(
                              nameController.text,
                              emailController.text,
                              passController.text,
                              context);
                        }
                      }),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Already Register?",
                        style: TextStyle(
                            fontSize: 15.0, color: Colors.black45.withOpacity(0.4)),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: const Text(
                            'Login Now',
                            style: TextStyle(color: Colors.black45),
                          ))
                    ],
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
