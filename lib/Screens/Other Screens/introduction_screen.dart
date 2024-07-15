import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:Todo_list_App/Backend/data/colors.dart';
import 'package:Todo_list_App/Screens/Other Screens/Authentication/login_screen.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_buttons.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../Backend/data/strings.dart';

class MyIntroductionScreen extends StatefulWidget {
  const MyIntroductionScreen({Key? key}) : super(key: key);

  @override
  State<MyIntroductionScreen> createState() => _MyIntroductionScreenState();
}

class _MyIntroductionScreenState extends State<MyIntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        globalBackgroundColor: kBGColor,
        pages: [
          PageViewModel(
            title: title,
            body:
                'Welcome to To Doodle Do! Experience the ultimate productivity '
                'tool for managing your tasks effectively. With a sleek and user-friendly '
                'interface, it helps you stay organized and focused.',
            image: Image.asset(
              'assets/1.png',
              fit: BoxFit.cover,
            ),
          ),
          PageViewModel(
            title: title,
            body: ' Create multiple to-do lists, add '
                'tasks with due dates and priorities, and track your progress '
                'effortlessly. With real-time synchronization powered by '
                'Firebase, access your tasks anytime, anywhere.',
            image: Image.asset(
              'assets/2.png',
              fit: BoxFit.cover,
            ),
          ),
          PageViewModel(
            title: title,
            body: ' Stay on top of your tasks with reminders and '
                'notifications. Boost your productivity and achieve your goals w'
            'ith To Doodle Do. ',
            image: Image.asset(
              'assets/3.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
        showBackButton: false,
        showNextButton: true,
        //isBottomSafeArea: true,
        showSkipButton: true,
        skip: MyTextButton(
            name: 'Skip',
            onTap: () {
              Get.off(() => const LoginScreen());
            }),
        next: const Icon(
          Icons.arrow_forward,
          color: kPrimaryColor,
          size: 30,
        ),
        done: const Text(
          'Continue',
          style: TextStyle(
              fontSize: 17, color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        onDone: () {
          Get.off(() => const LoginScreen());
        },
        dotsDecorator: DotsDecorator(
            size: const Size(10, 15),
            activeColor: Colors.deepPurple,
            activeSize: const Size(10, 15),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            )),
      ),
    );
  }
}
