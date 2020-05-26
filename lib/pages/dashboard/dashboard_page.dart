import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/pages/dashboard/components/profile_drawer.dart';
import 'package:huddlelabs/pages/dashboard/components/project_body.dart';
import 'package:huddlelabs/pages/dashboard/components/task_body.dart';
import 'package:huddlelabs/utils/components/huddle_scaffold.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<HuddleScaffoldState> _scaffoldKey = GlobalKey();
  bool isProjectView = true;
  String selectedProjectId = '', selectedTaskId = '';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Builder(
      builder: (context) {
        final String uid = fb.auth().currentUser.uid;

        if (uid != null && uid.isNotEmpty) {
          return HuddleScaffold(
            Scaffold(
              backgroundColor: Color(0xffF7F7FD),
              body: Row(
                children: <Widget>[
                  ProfileDrawer(selectedProjectId, (project) {
                    setState(() {
                      this.selectedProjectId = project;
                      isProjectView = true;
                    });
                  }),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        child: isProjectView
                            ? ProjectBody()
                            : TaskBody(selectedTaskId, uid),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            key: _scaffoldKey,
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
