import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/pages/dashboard/dashboard_page.dart';
import 'package:huddlelabs/pages/login/login_page.dart';
import 'package:huddlelabs/pages/project/project_details_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (fb.apps.isEmpty)
      fb.initializeApp(
          apiKey: "AIzaSyCBaX2aLaefJfckYKFwdUS4-dOLkn--R1Y",
          authDomain: "huddle-labs.firebaseapp.com",
          databaseURL: "https://huddle-labs.firebaseio.com",
          projectId: "huddle-labs",
          storageBucket: "huddle-labs.appspot.com",
          messagingSenderId: "1059796789632",
          appId: "1:1059796789632:web:875b6fc2adcd21069cb965",
          measurementId: "G-99W9V396S5");
  } catch (e, s) {
    print('$e,$s');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          fontFamily: 'Lato',
          buttonColor: Color(0xFF7754F6),
          primaryColor: Color(0xFF005CEA),
          // accentColor: Color(0xFF005CEA),
          // scaffoldBackgroundColor: Color(0xFFF4F4FA)
        ),
        theme: ThemeData(
          fontFamily: 'Lato',
          buttonColor: Color(0xFF7754F6),
          primaryColor: Color(0xFF005CEA),
          // accentColor: Color(0xFF005CEA),
          // scaffoldBackgroundColor: Color(0xFFF4F4FA)
        ),
        home: ProjectDetailsPage('4A9IN5PBVr1ZiAtyd5bs'));
        //     Builder(
        //   builder: (context) {
        //     fb.User user = fb.auth().currentUser;
        //     if (user != null && user.uid != null && user.uid.isNotEmpty) {
        //       return DashboardPage();
        //     }
        //     return LoginPage();
        //   },
        // ));
  }
}
