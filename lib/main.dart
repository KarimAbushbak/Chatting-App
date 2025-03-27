import 'package:chattingapp/config/dependancy_injection.dart';
import 'package:chattingapp/core/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await initModule();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.registerView,
      onGenerateRoute: RouteGenerator.getRoute,
    );
  }
}


