import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:time_track/styles/colors/colors.dart';
import 'package:time_track/ui/pages/history/history_page.dart';
import 'package:time_track/ui/pages/home_page/widgets/camera.dart';
import 'package:time_track/ui/pages/login_page/change_password.dart';
import 'package:time_track/ui/pages/login_page/login_page.dart';

import 'package:time_track/ui/pages/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Add this

  await FaceCamera.initialize(); //Add this
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TimeTrack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MyColors.themePrimaryColor,
          fontFamily: 'JetBrainsMono',
        ),
        home: const SplashPage(),
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
          SplashPage.routeName: (context) => const SplashPage(),
          MyCamera.routeName: (context) => const MyCamera(),
          HistoryPage.routeName: (context) => const HistoryPage(),
        });
  }
}

// The rest of your code and classes...
