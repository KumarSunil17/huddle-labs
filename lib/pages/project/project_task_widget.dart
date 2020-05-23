import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String title;
  final List<DocumentSnapshot> tasks;
  final VoidCallback onAddTask;
  const TaskWidget({this.onAddTask, this.tasks, this.title});

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
          Text('$title', style: TextStyle(fontSize: 16, color: Colors.black)),
          ListView.builder(
              padding: const EdgeInsets.only(top: 12),
              shrinkWrap: true,
              itemCount: 4, //tasks.length,
              itemBuilder: (c, index) => TaskCard(null)),
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
    );
  }
}

class TaskCard extends StatelessWidget {
  final DocumentSnapshot doc;
  const TaskCard(this.doc);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('${doc.data()['name']}')
                    Text('Task name'),
                    Row(children: [
                      Material(
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text('Deadline'),
                        ),
                      ),
                      Spacer(),
                      Tooltip(
                        message: 'User name',
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xfffDFE1E6),
                          child: Text(
                            'H',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      )
                    ])
                  ])),
        ));
  }
}
