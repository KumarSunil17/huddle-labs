import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/project/manage_members_page_page.dart';
import 'package:huddlelabs/pages/project/project_graphs.dart';
import 'package:huddlelabs/pages/project/project_task_widget.dart';
import 'package:huddlelabs/pages/task/add_task_dialog.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:huddlelabs/utils/enums.dart';
import 'package:firebase/firebase.dart' as fb;

class ProjectDetailsPage extends StatelessWidget {
  final String projectId;
  const ProjectDetailsPage(this.projectId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: projectCollection.doc(projectId).onSnapshot,
        builder: (c, projectSnapshot) {
          if (projectSnapshot.hasData)
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 32),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 42),
                              Text(
                                '${projectSnapshot.data.data()['name']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                        color: Color(0xff555555),
                                        fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  '${projectSnapshot.data.data()['description']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color: Color(0xff555555),
                                      )),
                              SizedBox(
                                height: 22,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text('Total members',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          '${(projectSnapshot.data.data()['members'] as List).length}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(color: Colors.black)),
                                      if (projectSnapshot.data
                                              .data()['createdBy'] ==
                                          fb.auth().currentUser.uid)
                                        FlatButton(
                                          child: Text('Manage members',
                                              style: TextStyle(fontSize: 16)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                FadeRoute(
                                                    page: ManageMembersPagePage(
                                                        projectId)));
                                          },
                                          textColor:
                                              Theme.of(context).primaryColor,
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 22,
                                  ),
                                  Column(
                                    children: [
                                      Text('Completed tasks',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text('---',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(color: Colors.black)),
                                      FlatButton(
                                        child: Text('View',
                                            style: TextStyle(fontSize: 16)),
                                        onPressed: () {},
                                        textColor:
                                            Theme.of(context).primaryColor,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          ProjectTaskGraph({
                            'Created': 12,
                            'Submitted': 12,
                            'Completed': 13
                          }),
                          SizedBox(
                            width: 20,
                          ),
                          ProjectUsersGraph({
                            'Sunil': 122,
                            'James': 22,
                            'Cheb': 72,
                            'Abc': 65,
                            'Fda': 62,
                            'Wte': 32,
                          }),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TaskWidget(
                                onAddTask: () =>
                                  _addTask(context, TaskStatus.created.toInt),
                                title: TaskStatus.created.toTaskString,
                                status: TaskStatus.created.toInt,
                                projectId: projectId,
                              ),
                            ),
                            Expanded(
                              child: TaskWidget(
                                onAddTask: () =>
                                    _addTask(context, TaskStatus.running.toInt),
                                status: TaskStatus.running.toInt,
                                projectId: projectId,
                                title: TaskStatus.running.toTaskString,
                              ),
                            ),
                            Expanded(
                              child: TaskWidget(
                                onAddTask: () =>
                                    _addTask(context, TaskStatus.submitted.toInt),
                                status: TaskStatus.submitted.toInt,
                                projectId: projectId,
                                title: TaskStatus.submitted.toTaskString,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Transactions',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: transactionCollection.onSnapshot,
                          builder: (c, s) {
                            if (s.hasData) {
                              final List<DocumentSnapshot> data = s.data.docs
                                  .where((element) =>
                                      element.data()['projectId'] == projectId)
                                  .toList();
                              return ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                children: List.generate(
                                    data.length,
                                    (index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
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
                )
              ],
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
