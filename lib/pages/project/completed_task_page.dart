import 'package:flutter/material.dart';

class CompletedTaskPage extends StatefulWidget {
  static const String routeName = '/completedTask';
  final String projectId;
  const CompletedTaskPage(this.projectId);
  @override
  _CompletedTaskPageState createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CompletedTask'),
      ),
    );
  }
}
