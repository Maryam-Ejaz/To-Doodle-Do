import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:Todo_list_App/Screens/Authentication/forgot_passwprd_screen.dart';
import 'package:Todo_list_App/Screens/Authentication/signup_screen.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_buttons.dart';
import 'package:Todo_list_App/Screens//custom_widgets/custom_snackbars.dart';
import 'package:Todo_list_App/Screens//custom_widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:Todo_list_App/data/themes.dart';
import 'package:Todo_list_App/providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, child) {
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
                      'Hello Again!',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.black26),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Welcome back you have\n been missed',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: Colors.black45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.alternate_email,
                      color: Color(0xff43025f),
                    ),
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.lock_open,
                      color: Color(0xff43025f),
                    ),
                    controller: passController,
                    obscure: !loginProvider.isPasswordVisible,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        loginProvider.togglePasswordVisibility();
                      },
                      icon: Icon(
                        loginProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: const Text(
                        'Recovery Password',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  MyButtonLong(
                      name: 'Sign In',
                      onTap: () {
                        if (emailController.text.isEmpty ||
                            passController.text.isEmpty) {
                          return CustomSnackBar.showError(
                              'Please fill all the fields');
                        }
                        loginProvider.signInWithEmailAndPassword(
                            emailController.text, passController.text, context);
                      }),
                  const SizedBox(height: 20.0),
                  // Row(
                  //   children: const [
                  //     SizedBox(width: 20),
                  //     Expanded(child: Divider(color: kBlack)),
                  //     SizedBox(width: 20),
                  //     Text('OR'),
                  //     SizedBox(width: 20),
                  //     Expanded(child: Divider(color: kBlack)),
                  //     SizedBox(width: 20),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Not a Member?",
                        style: TextStyle(
                            fontSize: 15.0, color:Colors.black45.withOpacity(0.4)),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const SignUpScreen());
                          },
                          child: const Text(
                            'Register Now',
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
