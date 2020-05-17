import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/pages/dashboard/components/profile_drawer.dart';
import 'package:huddlelabs/pages/dashboard/components/project_body.dart';
import 'package:huddlelabs/pages/dashboard/components/task_body.dart';
import 'package:huddlelabs/utils/components/huddle_scaffold.dart';
import 'package:huddlelabs/utils/components/responsive_widget.dart';

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
    final Widget yourProjectsList = GridView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4),
        itemCount: 4,
        itemBuilder: (c, i) {
          if (i == 0) {
            return AddProjectCard();
          } else
            return ProjectCard(
              createdAt: '22/05/2020',
              name: 'Demo project',
              desc: 'A project with dfemo desc.',
            );
        });

    final Widget assignedProjectsList = GridView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4),
        itemCount: 4,
        itemBuilder: (c, i) {
          return ProjectCard(
            createdAt: '22/05/2020',
            name: 'Demo project',
            desc: 'A project with dfemo desc.',
          );
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
          yourProjectsList,
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
          assignedProjectsList
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
          yourProjectsList,
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
          assignedProjectsList
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
          GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8),
              itemCount: 4,
              itemBuilder: (c, i) {
                if (i == 0) {
                  return AddProjectCard();
                } else
                  return ProjectCard(
                    createdAt: '22/05/2020',
                    name: 'Demo project',
                    desc: 'A project with dfemo desc.',
                  );
              }),
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
          GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8),
              itemCount: 4,
              itemBuilder: (c, i) {
                return ProjectCard(
                  createdAt: '22/05/2020',
                  name: 'Demo project',
                  desc: 'A project with dfemo desc.',
                );
              })
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

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 350,
          margin: const EdgeInsets.all(kToolbarHeight),
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    children: <Widget>[
                      Material(
                          color: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.red,
                          clipBehavior: Clip.antiAlias,
                          shape: CircleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3)),
                          child: Image.network(
                              'https://image.freepik.com/free-psd/mobile-phone-3d-mock-up-arrows_23-2148462085.jpg',
                              fit: BoxFit.cover,
                              height: 200,
                              width: 200)),
                      Positioned(
                          right: 8,
                          bottom: 8,
                          height: 36,
                          width: 36,
                          child: FloatingActionButton(
                            onPressed: () {},
                            elevation: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.add_a_photo, size: 16),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Text('sadadasd',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
                SizedBox(
                  height: 8,
                ),
                Text('skmuduli17@gmail.com', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 2,
                ),
                Text('+919090132200', style: TextStyle(fontSize: 16)),
                SizedBox(height: 32),
                OutlineButton(
                  onPressed: () {},
                  child: Text('Sign out'),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Privacy policy',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Text('.'),
                    FlatButton(
                      onPressed: () {},
                      child: Text('Terms and Conditions',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddProjectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
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
  final String name, desc, createdAt;
  const ProjectCard({this.createdAt: '', this.desc: '', this.name: ''});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
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
