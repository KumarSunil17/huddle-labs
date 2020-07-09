import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:huddlelabs/pages/dashboard/components/profile_dialog.dart';
import 'package:huddlelabs/pages/dashboard/dashboard_page.dart';
import 'package:huddlelabs/pages/dashboard/notification_drawer.dart';
import 'package:huddlelabs/pages/project/manage_members_page_page.dart';
import 'package:huddlelabs/pages/project/project_graphs.dart';
import 'package:huddlelabs/pages/project/project_task_widget.dart';
import 'package:huddlelabs/pages/task/add_task_dialog.dart';
import 'package:huddlelabs/pages/task/completed_task_page.dart';
import 'package:huddlelabs/pages/task/task_details_dialog_page.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:huddlelabs/utils/enums.dart';

class ProjectDetailsPage extends StatelessWidget {
  final String projectId;
  const ProjectDetailsPage(this.projectId);
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 43),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(width: 0.6, color: Colors.grey))),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                RawMaterialButton(
                  shape: CircleBorder(),
                  constraints: BoxConstraints.tightFor(height: 36, width: 36),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        FadeRoute(page: DashboardPage()), (route) => false);
                  },
                  child: Icon(Icons.home, color: Color(0xFF212121)),
                ),
                Spacer(),
                Text(
                  'Huddle labs',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      fontFamily: 'PoorRich',
                      color: Color.fromARGB(255, 21, 21, 21),
                      letterSpacing: 1.3),
                ),
                Spacer(),
                RawMaterialButton(
                  shape: CircleBorder(),
                  constraints: BoxConstraints.tightFor(height: 36, width: 36),
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                  child: Icon(Icons.notifications, color: Color(0xFF212121)),
                ),
                RawMaterialButton(
                  shape: CircleBorder(),
                  constraints: BoxConstraints.tightFor(height: 36, width: 36),
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
                  child: Icon(Icons.person, color: Color(0xFF212121)),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            )),
      ),
      endDrawer: NotificationDrawer(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: projectCollection.doc(projectId).onSnapshot,
        builder: (c, projectSnapshot) {
          if (projectSnapshot.hasData)
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1530,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            SizedBox(height: 32),
                            Expanded(
                              flex: 3,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: taskCollection
                                    .where('projectId', '==', projectId)
                                    .onSnapshot,
                                builder: (c, taskSnapshot) {
                                  final List<String> members = List.from(
                                          projectSnapshot.data
                                              .data()['members'])
                                      .map((e) => e.toString())
                                      .toList();

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ///title, description
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${projectSnapshot.data.data()['name']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                      color: Color(0xff555555),
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            Text(
                                                '${projectSnapshot.data.data()['description']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .copyWith(
                                                      color: Color(0xff555555),
                                                    )),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ProjectTaskGraph(
                                            {
                                              'Created': taskSnapshot.hasData
                                                  ? taskSnapshot.data.docs
                                                      .where((element) =>
                                                          element.data()[
                                                              'status'] ==
                                                          TaskStatus
                                                              .created.toInt)
                                                      .toList()
                                                      .length
                                                  : 1,
                                              'Submitted': taskSnapshot.hasData
                                                  ? taskSnapshot.data.docs
                                                      .where((element) =>
                                                          element.data()[
                                                              'status'] ==
                                                          TaskStatus
                                                              .submitted.toInt)
                                                      .toList()
                                                      .length
                                                  : 0,
                                              'Completed': taskSnapshot.hasData
                                                  ? taskSnapshot.data.docs
                                                      .where((element) =>
                                                          element.data()[
                                                              'status'] ==
                                                          TaskStatus
                                                              .completed.toInt)
                                                      .toList()
                                                      .length
                                                  : 0,
                                              'Running': taskSnapshot.hasData
                                                  ? taskSnapshot.data.docs
                                                      .where((element) =>
                                                          element.data()[
                                                              'status'] ==
                                                          TaskStatus
                                                              .running.toInt)
                                                      .toList()
                                                      .length
                                                  : 0,
                                            },
                                            taskSnapshot.hasData
                                                ? taskSnapshot.data.docs.length
                                                : 0),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: RaisedButton(
                                                      color: Colors.white,
                                                      hoverElevation: 8,
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            FadeRoute(
                                                                page: CompletedTaskPage(
                                                                    projectId)));
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Spacer(),
                                                          Text(
                                                              '${taskSnapshot.hasData ? taskSnapshot.data.docs.where((element) => element.data()['status'] == TaskStatus.completed.toInt).toList().length : ''}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black)),
                                                          Text(
                                                              'Completed tasks',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Spacer(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'View',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                              ),
                                                              Icon(
                                                                  Icons
                                                                      .navigate_next,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)
                                                            ],
                                                          ),
                                                          SizedBox(height: 4)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Expanded(
                                                    child: RaisedButton(
                                                      color: Colors.white,
                                                      hoverElevation: 8,
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            FadeRoute(
                                                                page: ManageMembersPagePage(
                                                                    projectId)));
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Spacer(),
                                                          Text(
                                                              '${(projectSnapshot.data.data()['members'] as List).length}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black)),
                                                          Text('Members',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                          Spacer(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'Manage members',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                              ),
                                                              Icon(
                                                                  Icons
                                                                      .navigate_next,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)
                                                            ],
                                                          ),
                                                          SizedBox(height: 4)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Expanded(
                                              child: taskSnapshot.hasData
                                                  ? StreamBuilder<
                                                          QuerySnapshot>(
                                                      stream: usersCollection
                                                          .onSnapshot,
                                                      builder:
                                                          (ctx, userSnapshot) {
                                                        if (userSnapshot
                                                            .hasData) {
                                                          Map<String, int>
                                                              usersTasks = {};

                                                          userSnapshot.data.docs
                                                              .forEach((user) {
                                                            members.forEach(
                                                                (member) {
                                                              if (user.id == member)
                                                                usersTasks[
                                                                    user.data()[
                                                                        'name']] = taskSnapshot
                                                                    .data.docs
                                                                    .where((element) =>
                                                                        element.data()['assignedBy'] ==
                                                                            member ||
                                                                        element.data()['assignedTo'] ==
                                                                            member)
                                                                    .toList()
                                                                    .length;
                                                            });
                                                          });
                                                          return ProjectUsersGraph(
                                                              usersTasks);
                                                        }
                                                        return Container();
                                                      })
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Expanded(
                              flex: 4,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TaskWidget(
                                      onAddTask: () => _addTask(
                                          context, TaskStatus.created.toInt),
                                      title: TaskStatus.created.toTaskString,
                                      status: TaskStatus.created.toInt,
                                      projectId: projectId,
                                    ),
                                  ),
                                  Expanded(
                                    child: TaskWidget(
                                      onAddTask: () => _addTask(
                                          context, TaskStatus.running.toInt),
                                      status: TaskStatus.running.toInt,
                                      projectId: projectId,
                                      title: TaskStatus.running.toTaskString,
                                    ),
                                  ),
                                  Expanded(
                                    child: TaskWidget(
                                      onAddTask: () => _addTask(
                                          context, TaskStatus.submitted.toInt),
                                      status: TaskStatus.submitted.toInt,
                                      projectId: projectId,
                                      title: TaskStatus.submitted.toTaskString,
                                    ),
                                  ),
                                  Expanded(
                                    child: MembersWidget(
                                      projectId: projectId,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(-2, 0),
                                    blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transactions',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: transactionCollection
                                      .orderBy('createdAt', 'desc')
                                      .onSnapshot,
                                  builder: (c, s) {
                                    if (s.hasData) {
                                      final List<DocumentSnapshot> data = s
                                          .data.docs
                                          .where((element) =>
                                              element.data()['projectId'] ==
                                              projectId)
                                          .toList();
                                      return ListView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        children: List.generate(
                                            data.length,
                                            (index) => ListTile(
                                                  onTap:
                                                      data[index].data()[
                                                                  'taskId'] ==
                                                              null
                                                          ? null
                                                          : () {
                                                              showGeneralDialog(
                                                                barrierLabel:
                                                                    "task-details",
                                                                barrierDismissible:
                                                                    true,
                                                                context:
                                                                    context,
                                                                barrierColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                transitionDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            300),
                                                                pageBuilder: (context,
                                                                        anim1,
                                                                        anim2) =>
                                                                    TaskDetailsDialog(
                                                                        data[index]
                                                                            .data()['taskId']),
                                                              );
                                                            },
                                                  hoverColor:
                                                      data[index].data()[
                                                                  'taskId'] ==
                                                              null
                                                          ? null
                                                          : Colors.blueAccent
                                                              .withOpacity(0.5),
                                                  mouseCursor:
                                                      data[index].data()[
                                                                  'taskId'] ==
                                                              null
                                                          ? MouseCursor.defer
                                                          : null,
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  title: Text(
                                                      '${data[index].data()['message']}'),
                                                )),
                                      );
                                    }
                                    return HuddleLoader(
                                        color: Theme.of(context).primaryColor);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          return HuddleLoader(color: Theme.of(context).primaryColor);
        },
      ),
    );
  }

  void _addTask(BuildContext context, int status) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: 'add-task-dialog',
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
          return AddTaskDialog(
            projectId: projectId,
            status: status,
          );
        });
  }
}
