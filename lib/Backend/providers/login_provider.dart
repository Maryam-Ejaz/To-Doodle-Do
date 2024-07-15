import 'dart:convert';
import 'dart:math';

import 'package:Todo_list_App/Backend/providers/task_provider.dart';
import 'package:Todo_list_App/Screens/MenuDrawer/DrawerState.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:Todo_list_App/Screens/custom_widgets/custom_snackbars.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:Todo_list_App/Screens/Other%20Screens/homepage.dart';

import '../../Screens/Other Screens/Authentication/login_screen.dart';
class LoginProvider extends ChangeNotifier {
  final Function _triggerRebuildMultiProvider;

  LoginProvider(Function triggerRebuildMultiProvider)
      : _triggerRebuildMultiProvider = triggerRebuildMultiProvider,
        super();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;


  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      CustomSnackBar.showSuccess('Login successful.');
      Provider.of<TaskProvider>(context, listen:false).fetchCategories_();
      Provider.of<TaskProvider>(context, listen:false).fetchTasks();
      Provider.of<TaskProvider>(context, listen:false).getUserName();
      dialog.dismiss();
      Get.offAll(() => const DrawerState());
    } catch (e) {
      CustomSnackBar.showError('Error signing in: $e');
      dialog.dismiss();

      rethrow;
    }
  }
  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      await _auth.sendPasswordResetEmail(email: email);
      CustomSnackBar.showSuccess('Password reset email sent');
      dialog.dismiss();
    } catch (e) {
      CustomSnackBar.showError('Error sending password reset email: $e');
      dialog.dismiss();
      rethrow;
    }
  }

  void logout() async {
    try {
      await _auth.signOut();
      await _auth.authStateChanges();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      notifyListeners();
      _triggerRebuildMultiProvider();
      CustomSnackBar.showSuccess('Logout successful');
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future loginUsingApple({required BuildContext context}) async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    debugPrint(
        "@Auth Service, Apple Login : Apple User Login Credentials => ${userCredential.user?.email}");
  }
}
