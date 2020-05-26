import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'add_project_dialog.dart';

class ManageMembersPagePage extends StatefulWidget {
  static const String routeName = '/manageProjectMembersPage';
  final String projectId;
  const ManageMembersPagePage(this.projectId);

  @override
  _ManageProjectMembersPagePageState createState() =>
      _ManageProjectMembersPagePageState();
}

class _ManageProjectMembersPagePageState extends State<ManageMembersPagePage> {
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        child: SizedBox(
          width: 1200,
          child: Row(
            children: [
              SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Members',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream:
                            projectCollection.doc(widget.projectId).onSnapshot,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            final List<String> members = List<String>.from(
                                snapshot.data.data()['members'].map((e) => e));

                            return ListView.builder(
                              itemCount: members.length,
                              itemBuilder: (c, i) {
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: usersCollection
                                      .doc(members[i])
                                      .onMetadataChangesSnapshot,
                                  builder: (BuildContext context, userSnap) {
                                    if (userSnap.hasData) {
                                      if (members[i] ==
                                          fb.auth().currentUser.uid) {
                                       return SmallUserWidget(
                                          avatar: userSnap.data.data()['photo'],
                                          name: userSnap.data.data()['name'],
                                          email: userSnap.data.data()['email']);
                                      }
                                      return SmallUserWidget(
                                          avatar: userSnap.data.data()['photo'],
                                          name: userSnap.data.data()['name'],
                                          email: userSnap.data.data()['email'],
                                          onDelete: () async {
                                            members.removeWhere((element) =>
                                                element == userSnap.data.id);
                                          
                                            notificationCollection.add({
                                              'createdAt': DateTime.now()
                                                  .toIso8601String(),
                                              'projectId': '',
                                              'read': false,
                                              'text':
                                                  'You have been removed from ${snapshot.data.data()['name']}.',
                                              'userId': userSnap.data.id
                                            });
                                            await transactionCollection.add({
                                              'createdAt': DateTime.now()
                                                  .toIso8601String(),
                                              'createdBy':
                                                  fb.auth().currentUser.uid,
                                              'message':
                                                  '${userSnap.data.data()['name']} was removed from ${snapshot.data.data()['name']}.',
                                              'projectId': widget.projectId
                                            });
                                            await projectCollection
                                                .doc(widget.projectId)
                                                .update(
                                                    data: {'members': members});
                                          });
                                    } else
                                      return Container();
                                  },
                                );
                              },
                            );
                          } else {
                            return HuddleLoader(
                                color: Theme.of(context).primaryColor);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(),
                              border: OutlineInputBorder(),
                              hintText: 'Search user...',
                              prefixIcon: Icon(Icons.search)),
                        )),
                    Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                      stream: usersCollection.onSnapshot,
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return HuddleErrorWidget(
                              message: '${snapshot.error.toString()}');
                        if (snapshot.hasData) {
                          if (_searchController.text.trim().isEmpty)
                            return HuddleErrorWidget(
                              message: 'Type keyword to search user...',
                            );
                          final List<DocumentSnapshot> data = snapshot.data.docs
                              .where((element) =>
                                  element.data()['name'].toString().contains(
                                      _searchController.text
                                          .trim()
                                          .toLowerCase()) ||
                                  element.data()['email'].toString().contains(
                                      _searchController.text
                                          .trim()
                                          .toLowerCase()))
                              .toList();
                          if (data.isEmpty) {
                            return HuddleErrorWidget(
                                message: 'No users found.');
                          }
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (c, index) {
                              if (data[index].id == fb.auth().currentUser.uid) {
                                return Container();
                              }
                              return UserListTile(
                                avatar: data[index].data()['photo'],
                                name: data[index].data()['name'],
                                email: data[index].data()['email'],
                                onPressed: () {
                                  projectCollection
                                      .doc(widget.projectId)
                                      .get()
                                      .then((project) async {
                                    final List<String> members =
                                        List<String>.from(project
                                            .data()['members']
                                            .map((e) => e));
                                    if (!members.contains(data[index].id)) {
                                      members.add(data[index].id);
                                      await projectCollection
                                          .doc(widget.projectId)
                                          .update(data: {'members': members});
                                      projectCollection
                                          .doc(widget.projectId)
                                          .get()
                                          .then((project) async {
                                        await notificationCollection.add({
                                          'createdAt':
                                              DateTime.now().toIso8601String(),
                                          'read': false,
                                          'projectId':project.id,
                                          'text':
                                              'You have been added to project ${project.data()['name']}.',
                                          'userId': data[index].id
                                        });
                                        await transactionCollection.add({
                                          'createdAt':
                                              DateTime.now().toIso8601String(),
                                          'createdBy':
                                              fb.auth().currentUser.uid,
                                          'message':
                                              '${data[index].data()['name']} has been added to project ${project.data()['name']}.',
                                          'projectId': widget.projectId
                                        });
                                      });
                                    }
                                  });
                                },
                              );
                            },
                          );
                        } else {
                          return HuddleLoader(
                              color: Theme.of(context).primaryColor);
                        }
                      },
                    ))
                  ],
                ),
              ),
              SizedBox(width: 32),
            ],
          ),
        ),
      ),
    );
  }
}
