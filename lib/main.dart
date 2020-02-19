import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

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
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(),
    );
  }
}
