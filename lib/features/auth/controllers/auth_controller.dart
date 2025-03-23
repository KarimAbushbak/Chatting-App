import 'package:chattingapp/core/extensions/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants.dart';
import '../../../core/routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userNameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordTextEditingController = TextEditingController();
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? nameError;

  Rxn<User> firebaseUser = Rxn<User>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection(Constants.usersDatabase).doc(userCredential.user!.uid).set({
        Constants.databaseIdColumnName: userCredential.user!.uid,
        Constants.databaseNameColumnName: name,
        Constants.databaseEmailColumnName: email,
        Constants.databaseNotesCreatedAt: DateTime.now(),
      });

      Get.snackbar("Success", "Account created successfully!");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Welcome", "Logged in successfully");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Login failed");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
  }

  resetErrors() {
    emailError = null;
    passwordError = null;
    confirmPasswordError = null;
    nameError = null;
  }

  void performRegister(BuildContext context) async {
    resetErrors();
    if (checkRegisterData(context)) {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await registerUser(
        context: context,
        name: userNameTextEditingController.text.trim(),
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      Get.back();
      Get.offAllNamed(Routes.homeScreen);
    }
    update();
  }

  bool checkRegisterData(BuildContext context) {
    return checkName(context) &&
        checkEmail(context) &&
        checkPassword(context) &&
        checkConfirmPassword(context);
  }

  bool checkName(BuildContext context) {
    if (userNameTextEditingController.text.isEmpty) {
      nameError = 'Username is required';
      showError(context, nameError);
      return false;
    }
    return true;
  }

  bool checkEmail(BuildContext context) {
    if (emailTextEditingController.text.isEmpty) {
      emailError = 'Email is required';
      showError(context, emailError);
      return false;
    }
    if (!emailTextEditingController.text.contains('@')) {
      emailError = 'Enter a valid email';
      showError(context, emailError);
      return false;
    }
    return true;
  }

  bool checkPassword(BuildContext context) {
    if (passwordTextEditingController.text.isEmpty) {
      passwordError = 'Password is required';
      showError(context, passwordError);
      return false;
    }
    if (passwordTextEditingController.text.length < 6) {
      passwordError = 'Password must be at least 6 characters';
      showError(context, passwordError);
      return false;
    }
    return true;
  }

  bool checkConfirmPassword(BuildContext context) {
    if (passwordTextEditingController.text !=
        confirmPasswordTextEditingController.text) {
      confirmPasswordError = 'Passwords do not match';
      showError(context, confirmPasswordError);
      return false;
    }
    return true;
  }

  void showError(BuildContext context, String? message) {
    Get.snackbar('Error', message.onNull(),
        backgroundColor: Colors.red, colorText: Colors.white);
  }
  void performLogin(BuildContext context, AuthController ctrl) async {
    ctrl.resetErrors();

    bool valid = true;

    if (ctrl.emailTextEditingController.text.isEmpty) {
      ctrl.emailError = 'Email is required';
      ctrl.showError(context, ctrl.emailError);
      valid = false;
    }

    if (ctrl.passwordTextEditingController.text.isEmpty) {
      ctrl.passwordError = 'Password is required';
      ctrl.showError(context, ctrl.passwordError);
      valid = false;
    }

    if (!valid) {
      ctrl.update();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await ctrl.loginUser(
      email: ctrl.emailTextEditingController.text.trim(),
      password: ctrl.passwordTextEditingController.text.trim(),
    );

    Get.back(); // close loading
    ctrl.update();
    Get.offAllNamed(Routes.homeScreen);
  }


  @override
  void onClose() {
    userNameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.onClose();
  }
}
