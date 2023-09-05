import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/controller/auth_controller.dart';
import 'package:todolist/views/home.dart';
import 'package:todolist/views/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo list using firebase',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: AppColorsp.primary),
      darkTheme:
          ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      themeMode: ThemeMode.system,
      home: Root(),
    );
  }
}

class Root extends StatelessWidget {
  Root({super.key});
  AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("${_authController.user.value}");
      return _authController.user.value == null ? LoginScreen() : Home();
    });
  }
}
