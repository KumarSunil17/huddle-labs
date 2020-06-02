import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/dashboard/components/other_profile_dialog.dart';
import 'package:huddlelabs/pages/dashboard/components/profile_dialog.dart';
import 'package:huddlelabs/pages/task/task_details_dialog_page.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:huddlelabs/utils/enums.dart';
import 'package:intl/intl.dart';
import 'package:firebase/firebase.dart' as fb;

class TaskWidget extends StatelessWidget {
  final String title;
  final int status;
  final String projectId;
  final VoidCallback onAddTask;
  const TaskWidget({this.onAddTask, this.title, this.status, this.projectId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffEBECF0),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      margin: const EdgeInsets.all(8),
      child: DragTarget<DocumentSnapshot>(
        onWillAccept: (data) {
          return true;
        },
        onAccept: (DocumentSnapshot doc) {
          if (doc.data()['status'] != status) {
            taskCollection
                .doc(doc.id)
                .update(data: {'status': status}).then((value) {
              usersCollection
                  .doc(fb.auth().currentUser.uid)
                  .get()
                  .then((currentUserDoc) {
                String currentUserName = currentUserDoc.data()['name'];
                transactionCollection.add({
                  'createdAt': DateTime.now().toIso8601String(),
                  'createdBy': fb.auth().currentUser.uid,
                  'message':
                      '$currentUserName changed ${doc.data()['title']} to ${taskStatusFromInt(status).toTaskString}',
                  'projectId': doc.data()['projectId'],
                  'taskId': doc.id,
                });
              });
            });
          }
        },
        builder: (context, candidateData, rejectedData) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title', style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 8),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: taskCollection
                      .where('projectId', '==', projectId)
                      .where('status', '==', status)
                      .onSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> tasks = snapshot.data.docs;
                      if (tasks.isNotEmpty) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            itemBuilder: (c, index) =>
                                Draggable<DocumentSnapshot>(
                                    data: tasks[index],
                                    feedback: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      child: SizedBox(
                                          width: 280,
                                          height: 75,
                                          child: TaskCard(tasks[index])),
                                    ),
                                    childWhenDragging: Material(
                                      clipBehavior: Clip.antiAlias,
                                      child: Opacity(
                                          opacity: 0.5,
                                          child: TaskCard(tasks[index])),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: TaskCard(tasks[index]),
                                    )));
                      } else {
                        return Container(height: 0);
                      }
                    } else {
                      return Container(height: 0);
                    }
                  }),
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton.icon(
                      color: Colors.transparent,
                      elevation: 0,
                      disabledElevation: 0,
                      highlightElevation: 0,
                      onPressed: onAddTask,
                      icon: Icon(Icons.add),
                      label: Text('Add task')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final DocumentSnapshot doc;
  const TaskCard(this.doc);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            showGeneralDialog(
              barrierLabel: "task-details",
              barrierDismissible: true,
              context: context,
              barrierColor: Colors.black.withOpacity(0.5),
              transitionDuration: Duration(milliseconds: 300),
              pageBuilder: (context, anim1, anim2) => TaskDetailsDialog(doc.id),
            );
          },
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${doc.data()['title']}'),
                    Row(children: [
                      Tooltip(
                        message: getDeadlineString(doc.data()['expiresAt']),
                        preferBelow: false,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                              colors: [Color(0xff6a11cb), Color(0xff2575fc)]),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(6),
                          color:
                              doc.data()['status'] == TaskStatus.completed.toInt
                                  ? Color(0xff00cf00)
                                  : getDeadlineColor(doc.data()['expiresAt']),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              DateFormat('EEE, MMM d, yyyy').format(
                                  DateTime.parse(doc.data()['expiresAt'])),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      StreamBuilder<DocumentSnapshot>(
                          stream: usersCollection
                              .doc(doc.data()['assignedTo'])
                              .onSnapshot,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Tooltip(
                                message: '${snapshot.data.data()['name']}',
                                preferBelow: false,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(colors: [
                                    Color(0xff6a11cb),
                                    Color(0xff2575fc)
                                  ]),
                                ),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xfffDFE1E6),
                                  child: Text(
                                    '${snapshot.data.data()['name'].toString()[0]}',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          })
                    ])
                  ])),
        ));
  }
}

class MembersWidget extends StatelessWidget {
  final String projectId;
  const MembersWidget({this.projectId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffEBECF0),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Members', style: TextStyle(fontSize: 16, color: Colors.black)),
          SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
                stream: projectCollection.doc(projectId).onSnapshot,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<String> members = List<String>.from(snapshot.data
                        .data()['members']
                        .map((e) => e.toString())).toList();

                    if (members.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: members.length,
                          itemBuilder: (c, index) =>
                              StreamBuilder<DocumentSnapshot>(
                                stream: usersCollection
                                    .doc(members[index])
                                    .onSnapshot,
                                builder: (c, user) {
                                  if (user.hasData) {
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      clipBehavior: Clip.antiAlias,
                                      child: ListTile(
                                        onTap: () {
                                          showGeneralDialog(
                                            barrierLabel: "other-profile",
                                            barrierDismissible: true,
                                            context: context,
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            transitionDuration:
                                                Duration(milliseconds: 300),
                                            pageBuilder:
                                                (context, anim1, anim2) =>
                                                    OtherProfileWidget(
                                                        user.data.id),
                                          );
                                        },
                                        leading: Material(
                                          type: MaterialType.circle,
                                          color: Colors.grey.withOpacity(0.3),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/placeholder.png',
                                            image:
                                                user.data.data()['photo'] ?? '',
                                            fit: BoxFit.cover,
                                            height: 42,
                                            width: 42,
                                          ),
                                        ),
                                        title:
                                            Text('${user.data.data()['name']}'),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ));
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
