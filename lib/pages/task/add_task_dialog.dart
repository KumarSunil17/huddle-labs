import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huddlelabs/pages/project/add_project_dialog.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {
  final int status;
  final String projectId;

  AddTaskDialog({@required this.status, @required this.projectId});
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  TextEditingController _searchController;
  DocumentSnapshot assignedTo;
  final GlobalKey<HuddleButtonState> _buttonKey =
      GlobalKey<HuddleButtonState>();
  TextEditingController _title, _desc;
  String _dateStr = 'Due Date*';
  DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _desc = TextEditingController();
    _title = TextEditingController();
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _membersList = StreamBuilder<DocumentSnapshot>(
      stream: projectCollection.doc(widget.projectId).onSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return HuddleErrorWidget(message: '${snapshot.error.toString()}');
        if (snapshot.hasData) {
          if (_searchController.text.trim().isEmpty)
            return HuddleErrorWidget(
              message: 'Type keyword to search user...',
            );

          List<dynamic> membersList = snapshot.data.data()['members'] as List;

          if (membersList.isEmpty) {
            return HuddleErrorWidget(message: 'No users found.');
          }

          return ListView.builder(
              itemCount: membersList.length,
              itemBuilder: (c, index) => StreamBuilder<DocumentSnapshot>(
                    stream: usersCollection.doc(membersList[index]).onSnapshot,
                    builder: (BuildContext ctx, userSnapshot) {
                      if (userSnapshot.hasData) {
                        String str =
                            _searchController.text.trim().toLowerCase();
                        if (userSnapshot.data
                            .data()['name']
                            .toString()
                            .toLowerCase()
                            .contains(str)) {
                          return UserListTile(
                            avatar: userSnapshot.data.data()['photo'],
                            name: userSnapshot.data.data()['name'],
                            email: userSnapshot.data.data()['email'],
                            onPressed: () {
                              setState(() {
                                assignedTo = userSnapshot.data;
                              });
                            },
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ));
        } else {
          return HuddleLoader(color: Theme.of(context).primaryColor);
        }
      },
    );
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [Text('Add task'), Spacer(), HuddleCloseButton()],
      ),
      children: [
        Row(
          children: [
            Expanded(
                child: AspectRatio(
                    aspectRatio: 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.grey.withOpacity(0.05),
                          child: TextFormField(
                              cursorColor: Color(0xff636363),
                              cursorWidth: 2.6,
                              autofocus: true,
                              controller: _title,
                              scrollPhysics: BouncingScrollPhysics(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                hintText: 'Title*',
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: Colors.black)),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                            color: Colors.grey.withOpacity(0.05),
                            child: TextFormField(
                                cursorColor: Color(0xff636363),
                                cursorWidth: 2.6,
                                controller: _desc,
                                maxLines: 3,
                                minLines: 3,
                                scrollPhysics: BouncingScrollPhysics(),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  hintText: 'Describe the task*',
                                  border: InputBorder.none,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Colors.black))),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.05),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.05))),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 6),
                            width: 230,
                            child: Text(
                              _dateStr == 'Due Date*'
                                  ? _dateStr
                                  : 'Due Date: $_dateStr',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Assigned to',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        assignedTo != null
                            ? SmallUserWidget(
                                avatar: assignedTo.data()['photo'],
                                name: assignedTo.data()['name'],
                                email: assignedTo.data()['email'],
                                onDelete: () =>
                                    setState(() => assignedTo = null))
                            : Container(),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ))),
            SizedBox(
              width: 12,
            ),
            Expanded(
                child: AspectRatio(
                    aspectRatio: 0.9,
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
                          ),
                        ),
                        Flexible(flex: 5, child: _membersList),
                        Flexible(
                            flex: 1,
                            child: Row(children: [
                              Spacer(flex: 2),
                              Container(
                                alignment: Alignment.topRight,
                                height: 54,
                                child: HuddleButton(
                                  text: 'Add Task',
                                  key: _buttonKey,
                                  onPressed: _addTask,
                                ),
                              ),
                            ]))
                      ],
                    ))),
          ],
        )
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 15));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dueDate = picked;
      });
    _dateStr = DateFormat("dd/MM/yyyy").format(selectedDate);
  }

  void _addTask() {
    if (_title.text.trim().isEmpty) {
      showSnackbar('Enter task title', context);
      return;
    }
    if (_desc.text.trim().isEmpty) {
      showSnackbar('Enter task description', context);
      return;
    }
    if (_dateStr == 'Due Date*') {
      showSnackbar('Enter Due Date', context);
      return;
    }
    if (assignedTo == null) {
      showSnackbar('Enter The Assignee', context);
      return;
    }
    _buttonKey.currentState.showLoader();
    try {
      taskCollection.add({
        'title': _title.text.trim(),
        'description': _desc.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
        'expiresAt': _dueDate.toIso8601String(),
        'status': widget.status,
        'assignedTo': assignedTo.id,
        'assignedBy': fb.auth().currentUser.uid,
        'projectId': widget.projectId
      }).then((taskRef) {
        usersCollection.doc(assignedTo.id).get().then((assignedUserDoc) {
          String assignedToName = assignedUserDoc.data()['name'];
          usersCollection
              .doc(fb.auth().currentUser.uid)
              .get()
              .then((currentUserDoc) {
            String currentUserName = currentUserDoc.data()['name'];
            transactionCollection.add({
              'createdAt': DateTime.now().toIso8601String(),
              'createdBy': fb.auth().currentUser.uid,
              'message':
                  '$currentUserName assigned $assignedToName a task: ${_title.text.trim()}',
              'projectId': widget.projectId,
              'taskId': taskRef.id,
            }).then((value) {
              notificationCollection.add({
                'createdAt': DateTime.now().toIso8601String(),
                'projectId': value.id,
                'read': false,
                'text':
                    '$currentUserName assigned you a task: ${_title.text.trim()}',
                'userId': assignedTo.id
              });
            });
          });
        });
      }).whenComplete(() {
        _buttonKey.currentState.hideLoader();
        Navigator.pop(context);
      });
    } catch (_) {
      if (_ is PlatformException)
        showSnackbar(_?.message, context);
      else
        showSnackbar(_?.toString(), context);
    }
  }
}
