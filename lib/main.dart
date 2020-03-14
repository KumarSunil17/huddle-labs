import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/pages/dashboard/dashboard_page.dart';
import 'package:huddlelabs/pages/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(() {
    if (fb.apps.isEmpty) {
      fb.initializeApp(
          apiKey: "AIzaSyCBaX2aLaefJfckYKFwdUS4-dOLkn--R1Y",
          authDomain: "huddle-labs.firebaseapp.com",
          databaseURL: "https://huddle-labs.firebaseio.com",
          projectId: "huddle-labs",
          storageBucket: "huddle-labs.appspot.com",
          messagingSenderId: "1059796789632",
          appId: "1:1059796789632:web:875b6fc2adcd21069cb965",
          measurementId: "G-99W9V396S5");
    }
    return true;
  }());
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
          cardColor: Color(0xFFF6F4FC),
          // scaffoldBackgroundColor: Color(0xFFF4F4FA)
        ),
        theme: ThemeData(
          fontFamily: 'Lato',
          buttonColor: Color(0xFF7754F6),
          primaryColor: Color(0xFF005CEA),
          // accentColor: Color(0xFF005CEA),
          cardColor: Color(0xFFF6F4FC),
          // scaffoldBackgroundColor: Color(0xFFF4F4FA)
        ),
        home: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data is FirebaseUser) {
              FirebaseUser user = snapshot.data;
              if (user != null && user.uid != null && user.uid.isNotEmpty) {
                return DashboardPage();
              }
              return LoginPage();
            } else {
              return LoginPage();
            }
          },
        ));
  }
}