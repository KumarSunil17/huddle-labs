import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/components/responsive_widget.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:firebase/firebase.dart' as fb;

class AddProjectDialog extends StatefulWidget {
  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  TextEditingController _searchController;
  List<DocumentSnapshot> _selectedUsers = [];
  final GlobalKey<HuddleButtonState> _buttonKey =
      GlobalKey<HuddleButtonState>();
  TextEditingController _title, _desc;

  @override
  void initState() {
    super.initState();
    _desc = TextEditingController();
    _title = TextEditingController();
    _searchController = TextEditingController();
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
    final _allUsersList = StreamBuilder<QuerySnapshot>(
      stream: usersCollection.onSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return HuddleErrorWidget(message: '${snapshot.error.toString()}');
        if (snapshot.hasData) {
          final List<DocumentSnapshot> data = snapshot.data.docs
              .where((element) =>
                  element
                      .data()['name']
                      .toString()
                      .contains(_searchController.text.trim().toLowerCase()) &&
                  element.id != fb.auth().currentUser.uid)
              .toList();
          if (data.isEmpty) {
            return HuddleErrorWidget(message: 'No users found.');
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (c, index) => UserListTile(
              avatar: data[index].data()['photo'],
              name: data[index].data()['name'],
              email: data[index].data()['email'],
              onPressed: () {
                setState(() {
                  if (_selectedUsers
                      .where((element) => element.id == data[index].id)
                      .toList()
                      .isEmpty) _selectedUsers.add(data[index]);
                });
              },
            ),
          );
        } else {
          return HuddleLoader(color: Theme.of(context).primaryColor);
        }
      },
    );
    final Widget largeWidget = Row(
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
                              hintText:
                                  'Something about your project (optional)',
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.black))),
                    SizedBox(height: 12),
                    Text(
                      'Team members',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          scrollDirection: Axis.vertical,
                          itemCount: _selectedUsers.length,
                          itemBuilder: (c, index) => SmallUserWidget(
                              avatar: _selectedUsers[index].data()['photo'],
                              name: _selectedUsers[index].data()['name'],
                              email: _selectedUsers[index].data()['email'],
                              onDelete: () {
                                setState(() {
                                  _selectedUsers.remove(_selectedUsers[index]);
                                });
                              })),
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
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(),
                            border: OutlineInputBorder(),
                            hintText: 'Search user...',
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                    Flexible(flex: 5, child: _allUsersList),
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Spacer(flex: 2),
                          Container(
                            alignment: Alignment.topRight,
                            height: 54,
                            child: HuddleButton(
                              text: 'Add project',
                              key: _buttonKey,
                              onPressed: _addProject,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
      ],
    );

    final List<Widget> smallWidget = [
      Container(
        color: Colors.grey.withOpacity(0.05),
        child: TextFormField(
            cursorColor: Color(0xff636363),
            cursorWidth: 2.6,
            controller: _title,
            scrollPhysics: BouncingScrollPhysics(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              hintText: 'Title*',
              border: InputBorder.none,
            ),
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.black)),
      ),
      Container(
          color: Colors.grey.withOpacity(0.05),
          child: TextFormField(
              cursorColor: Color(0xff636363),
              cursorWidth: 2.6,
              maxLines: 2,
              controller: _desc,
              minLines: 2,
              scrollPhysics: BouncingScrollPhysics(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                hintText: 'Something about your project (optional)',
                border: InputBorder.none,
              ),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black))),
      SizedBox(
        height: 8,
      ),
      Text(
        'Team members',
        style:
            Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),
      ),
      SizedBox(height: 8),
      Container(
          height: 150,
          width: 800,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _selectedUsers.length,
              itemBuilder: (c, index) => SmallUserWidget(
                  avatar: _selectedUsers[index].data()['photo'],
                  name: _selectedUsers[index].data()['name'],
                  email: _selectedUsers[index].data()['email'],
                  onDelete: () {
                    setState(() {
                      _selectedUsers.remove(_selectedUsers[index]);
                    });
                  }))),
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
      _allUsersList,
      SizedBox(height: 16),
      Row(
        children: [
          Spacer(flex: 2),
          Container(
            alignment: Alignment.topRight,
            height: 54,
            child: HuddleButton(
              text: 'Add project',
              key: _buttonKey,
              onPressed: _addProject,
            ),
          ),
        ],
      )
    ];

    return ResponsiveWidget(
      largeScreen: SimpleDialog(
          contentPadding: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [Text('Add project'), Spacer(), HuddleCloseButton()],
          ),
          children: [
            largeWidget,
          ]),
      smallScreen: SimpleDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [Text('Add project'), Spacer(), HuddleCloseButton()],
        ),
        children: smallWidget,
      ),
    );
  }

  _addProject() {
    if (_title.text.trim().isEmpty) {
      showSnackbar('Enter project title', context);
      return;
    }
    _buttonKey.currentState.showLoader();
    final List<String> members =
        List<String>.from(_selectedUsers.map((e) => e.id).toList());
    members.add(fb.auth().currentUser.uid);

    try {
      projectCollection.add({
        'name': _title.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
        'createdBy': fb.auth().currentUser.uid,
        'description': _desc.text.trim(),
        'members': members,
      }).then((value) {
        usersCollection
            .doc(fb.auth().currentUser.uid)
            .get()
            .then((currentUserDoc) {
          transactionCollection.add({
            'createdAt': DateTime.now().toIso8601String(),
            'createdBy': fb.auth().currentUser.uid,
            'message':
                '${currentUserDoc.data()['name']} created project ${_title.text.trim()}.',
            'projectId': value.id
          });
          final List<String> names = [];
          members.forEach((member) {
            usersCollection.doc(member).get().then((userDoc) {
              if (userDoc.id != fb.auth().currentUser.uid)
                names.add(userDoc.data()['name']);
              notificationCollection.add({
                'createdAt': DateTime.now().toIso8601String(),
                'projectId': value.id,
                'read': false,
                'text':
                    '${currentUserDoc.data()['name']} added you to project ${_title.text.trim()}.',
                'userId': member
              });
            });
          });
          transactionCollection.add({
            'createdAt': DateTime.now().toIso8601String(),
            'createdBy': fb.auth().currentUser.uid,
            'message':
                '${currentUserDoc.data()['name']} added ${names.join(', ')} to ${_title.text.trim()}.',
            'projectId': value.id
          });
        });
      }).whenComplete(() {
        _buttonKey.currentState.hideLoader();
      });
    } catch (e) {
      if (e is PlatformException)
        showSnackbar(e.message, context);
      else
        showSnackbar(e.toString(), context);
    }
  }
}

class SmallUserWidget extends StatelessWidget {
  final VoidCallback onDelete;
  final String avatar, email, name, phone;
  const SmallUserWidget(
      {this.onDelete, this.name, this.avatar, this.email, this.phone = ''});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.blue.withOpacity(0.5),
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  type: MaterialType.circle,
                  color: Colors.grey.withOpacity(0.3),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: avatar ?? '',
                    fit: BoxFit.cover,
                    height: 46,
                    width: 46,
                  ),
                ),
                if (onDelete != null)
                  RawMaterialButton(
                    highlightElevation: 0,
                    hoverElevation: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: CircleBorder(),
                    constraints: BoxConstraints.tightFor(height: 22, width: 22),
                    onPressed: onDelete,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    fillColor: Colors.red,
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '$name',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              '$email',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black87),
            ),
            if (phone.isNotEmpty)
              Text(
                '$phone',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black87),
              ),
          ],
        ),
      ),
    );
  }
}

class UserListTile extends StatelessWidget {
  final VoidCallback onPressed;
  final String avatar, email, name, phone;
  UserListTile(
      {this.onPressed, this.name, this.avatar, this.email, this.phone = ''});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Material(
              type: MaterialType.circle,
              color: Colors.grey.withOpacity(0.3),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: avatar ?? '',
                fit: BoxFit.cover,
                height: 42,
                width: 42,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(
                    '$name',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  SelectableText(
                    '$email',
                    style: TextStyle(color: Colors.black87),
                  ),
                  if (phone.isNotEmpty)
                    SelectableText(
                      '$phone',
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
