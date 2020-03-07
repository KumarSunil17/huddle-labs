import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/dashboard/components/profile_drawer.dart';
import 'package:huddlelabs/utils/components/huddle_scaffold.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return HuddleScaffold(
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Dashboard'),
        ),
        endDrawer: ProfileDrawer(''),
      ),
    );
  }
}
