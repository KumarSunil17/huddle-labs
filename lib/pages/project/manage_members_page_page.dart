import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/constants.dart';

class ManageMembersPagePage extends StatefulWidget {
  static const String routeName = '/manageProjectMembersPage';
  final String projectId;
  const ManageMembersPagePage(this.projectId);

  @override
  _ManageProjectMembersPagePageState createState() =>
      _ManageProjectMembersPagePageState();
}

class _ManageProjectMembersPagePageState extends State<ManageMembersPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: projectCollection.doc(widget.projectId).get(),
          builder: (BuildContext context, snapshot) {
            return Text(snapshot.hasData
                ? '${snapshot.data.data()['name']} members'
                : '');
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2,
              height: double.infinity,
              color: Colors.red,
              child: ListView(),
            )
          ],
        ),
      ),
    );
  }
}
