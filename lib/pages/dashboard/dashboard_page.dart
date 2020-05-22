import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/pages/project/add_project_dialog.dart';
import 'package:huddlelabs/pages/project/project_details_page.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/components/responsive_widget.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:intl/intl.dart';

import 'components/profile_dialog.dart';
import 'notification_drawer.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final double targetElevation = 3;
  double _elevation = 0;
  ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? targetElevation : 0;
    if (_elevation != newElevation) {
      setState(() {
        _elevation = newElevation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget yourProjectsList(count) => StreamBuilder<QuerySnapshot>(
          stream: projectCollection.onSnapshot,
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: AddProjectCard());
            } else {
              final List<DocumentSnapshot> data = snapshot.data.docs
                  .where((element) =>
                      element.data()['createdBy'] == fb.auth().currentUser.uid)
                  .toList();
              return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4),
                  itemCount: data.length + 1,
                  itemBuilder: (c, i) {
                    if (i == 0) {
                      return AddProjectCard();
                    } else
                      return ProjectCard(
                        data[i - 1].id,
                        createdAt: DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(data[i - 1].data()['createdAt'])),
                        name: data[i - 1].data()['name'],
                        desc: data[i - 1].data()['description'],
                      );
                  });
            }
          },
        );
    Widget assignedProjectsList(count) => StreamBuilder<QuerySnapshot>(
        stream: projectCollection.onSnapshot,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> data = snapshot.data.docs
                .where((element) =>
                    element
                        .data()['members']
                        .contains(fb.auth().currentUser.uid) &&
                    element.data()['createdBy'] != fb.auth().currentUser.uid)
                .toList();

            return GridView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4),
                itemCount: data.length,
                itemBuilder: (c, i) {
                  return ProjectCard(
                    data[i].id,
                    createdAt: DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(data[i].data()['createdAt'])),
                    name: data[i].data()['name'],
                    desc: data[i].data()['description'],
                  );
                });
          }
          return Container();
        });

    final Widget largeScreen = Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 5,
        right: MediaQuery.of(context).size.width / 5,
        top: MediaQuery.of(context).size.height / 6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Your projects',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          yourProjectsList(3),
          Divider(color: Colors.grey, height: 28),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Projects assigned to you',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          assignedProjectsList(3)
        ],
      ),
    );
    final Widget mediumScreen = Padding(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        top: 48,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Your projects',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          yourProjectsList(3),
          Divider(color: Colors.grey, height: 28),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Projects assigned to you',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          assignedProjectsList(3)
        ],
      ),
    );
    final Widget smallScreen = Padding(
      padding: EdgeInsets.only(top: 43, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Your projects',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          yourProjectsList(1),
          Divider(color: Colors.grey, height: 28),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Projects assigned to you',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ),
          assignedProjectsList(1)
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('HuddleLabs'),
        elevation: _elevation,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
          IconButton(
            onPressed: () {
              showGeneralDialog(
                barrierLabel: "profile",
                barrierDismissible: true,
                context: context,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, anim1, anim2) => ProfileWidget(),
              );
            },
            icon: Icon(Icons.person),
          )
        ],
      ),
      endDrawer: NotificationDrawer(),
      body: SingleChildScrollView(
        controller: _controller,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset('assets/pic1.png', height: 200,),
                    Spacer(),
                    Image.asset('assets/pic2.png', height: 200,),
                  ],
                ),
              ),
            ),
            ResponsiveWidget(
              largeScreen: largeScreen,
              mediumScreen: mediumScreen,
              smallScreen: smallScreen,
            )
          ],
        ),
      ),
    );
  }
}

class AddProjectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          showGeneralDialog(
              barrierDismissible: true,
              barrierLabel: 'add-project-dialog',
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return Transform.scale(
                  scale: a1.value,
                  child: Opacity(opacity: a1.value, child: widget),
                );
              },
              transitionDuration: Duration(milliseconds: 300),
              context: context,
              pageBuilder: (context, animation1, animation2) {
                return AddProjectDialog();
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.blue,
                size: 36,
              ),
              Text(
                'Add project',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String name, desc, createdAt, projectId;
  const ProjectCard(this.projectId,
      {this.createdAt: '', this.desc: '', this.name: ''});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, FadeRoute(page: ProjectDetailsPage(this.projectId)));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                desc,
                style: TextStyle(color: Colors.black54),
              ),
              Spacer(),
              Text(
                createdAt,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
