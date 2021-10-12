import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/project/project_task_widget.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:huddlelabs/utils/enums.dart';

class CompletedTaskPage extends StatelessWidget {
  static const String routeName = '/completedTask';
  final String projectId;
  const CompletedTaskPage(this.projectId);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: taskCollection
              .where('projectId', '==', projectId)
              .where('status', '==', TaskStatus.completed.toInt)
              .onSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> tasks = snapshot.data!.docs;
              if (tasks.isNotEmpty) {
                return ListView.separated(
                    separatorBuilder: (c, i) => SizedBox(height: 8),
                    padding: const EdgeInsets.all(12),
                    itemCount: tasks.length,
                    itemBuilder: (c, index) => TaskCard(tasks[index]));
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
    );
  }
}
