import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final RegExp emailExpression = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp nameExpression = RegExp(r'^[A-Za-z ]+$');
final RegExp passwordExpression =
    RegExp(r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\S+$).{4,}$');
final RegExp phoneExpression = RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
const String MALE_PLACEHOLDER =
    'https://img.icons8.com/color/200/000000/circled-user-male-skin-type-5.png';
const String FEMALE_PLACEHOLDER =
    'https://img.icons8.com/color/200/000000/user-female-circle.png';

final CollectionReference usersCollection = fb.firestore().collection('user');
final CollectionReference projectCollection =
    fb.firestore().collection('project');
final CollectionReference notificationCollection =
    fb.firestore().collection('notification');
final CollectionReference taskCollection = fb.firestore().collection('task');
final CollectionReference chatCollection = fb.firestore().collection('chat');
final CollectionReference transactionCollection =
    fb.firestore().collection('transaction');

showSnackbar(String message, BuildContext context) {
  Flushbar(
    message: "$message",
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 400),
    maxWidth: 600,
    backgroundGradient:
        LinearGradient(colors: [Color(0xff6a11cb), Color(0xff2575fc)]),
  )..show(context);
}

Color getDeadlineColor(String dateString) {
  try {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateTime current = DateTime.now();
    final days = dateTime.difference(current).inDays;
    if (days.isNegative) {
      return Color(0xffcf0000);
    } else if (days == 0) {
      return Color(0xffFF7F00);
    } else {
      return Color(0xff00cf00);
    }
  } catch (e) {
    print(e);
    return Colors.grey;
  }
}

String getDeadlineString(String dateString) {
  try {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateTime current = DateTime.now();
    final days = dateTime.difference(current).inDays;
    if (days.isNegative) {
      return 'This task is past dued.';
    } else if (days == 0) {
      return 'This task will expire today.';
    } else {
      return 'This task will expire in $days days.';
    }
  } catch (e) {
    print(e);
    return 'Some error occurred.';
  }
}
