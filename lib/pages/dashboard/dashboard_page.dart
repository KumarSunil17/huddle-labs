import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/dashboard/components/profile_drawer.dart';
import 'package:huddlelabs/utils/components/huddle_scaffold.dart';

import 'components/dashboard_chart/dashboard_chart.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<HuddleScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final String uid = snapshot.data.uid;
          return HuddleScaffold(
            Scaffold(
              backgroundColor: Color(0xffF7F7FD),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Dashboard'),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.person, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: 'Open Profile',
                    ),
                  ),
                ],
              ),
              endDrawer: ProfileDrawer(uid, true),
              key: _scaffoldKey,
              body: Center(child: DashboardChart()),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
