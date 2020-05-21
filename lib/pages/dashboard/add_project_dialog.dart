import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/dashboard/components/huddle_small_profile.dart';
import 'package:huddlelabs/utils/components/empty_widget.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/pojo/user.dart' as user;

class AddProjectDialog extends StatefulWidget {
  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  List<DocumentSnapshot> _selectedUsers = [];
  TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 5,
          vertical: MediaQuery.of(context).size.height / 7),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 16,
                left: 16,
                child: Text(
                  'Add project',
                  style: TextStyle(
                      inherit: true,
                      fontSize: 20,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey),
                )),
            Positioned(top: 0, right: 0, child: HuddleCloseButton()),
            Positioned.fill(
                top: 70,
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.grey.withOpacity(0.05),
                        child: TextFormField(
                            cursorColor: Color(0xff636363),
                            cursorWidth: 2.6,
                            scrollPhysics: BouncingScrollPhysics(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              hintText: 'Title',
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(color: Colors.black)),
                      ),
                      SizedBox(height: 16),
                      Container(
                        color: Colors.grey.withOpacity(0.07),
                        child: TextFormField(
                            cursorColor: Color(0xff636363),
                            cursorWidth: 2.6,
                            maxLines: 4,
                            minLines: 4,
                            scrollPhysics: BouncingScrollPhysics(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              hintText: 'Something about your project',
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        color: Colors.grey.withOpacity(0.1),
                        child: TextFormField(
                            cursorColor: Color(0xff636363),
                            cursorWidth: 2.6,
                            scrollPhysics: BouncingScrollPhysics(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              hintText: 'Search for team member...',
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedUsers.length,
                              itemBuilder: (ctx, index) {
                                try {
                                  final user.User u = user.User.fromJson(
                                      _selectedUsers[index].data());
                                  return HuddleSmallProfile(u);
                                } catch (e) {
                                  print(e);
                                }
                                return Container();
                              },
                            ),
                            Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                              stream:
                                  firestore().collection('users').onSnapshot,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<DocumentSnapshot> documents =
                                      snapshot.data.docs;
                                  documents.removeWhere((element) =>
                                      element.id == auth().currentUser.uid);
                                  if (documents.isEmpty) {
                                    return HuddleEmptyWidget(
                                      message: 'No users found.',
                                    );
                                  }
                                  _selectedUsers = documents
                                      .where((element) =>
                                          element.data()['name'] ==
                                          _searchController.text
                                              .trim()
                                              .toLowerCase())
                                      .toList();
                                  documents.removeWhere((element) =>
                                      element.data()['name'] ==
                                      _searchController.text
                                          .trim()
                                          .toLowerCase());
                                  return AnimatedList(
                                    scrollDirection: Axis.horizontal,
                                    initialItemCount: documents.length,
                                    itemBuilder: (context, index, animation) {
                                      try {
                                        final user.User u = user.User.fromJson(
                                            documents[index].data());
                                        return HuddleSmallProfile(u);
                                      } catch (e) {
                                        print(e);
                                      }
                                      return Container();
                                    },
                                  );
                                } else {
                                  return HuddleLoader(
                                      color: Theme.of(context).primaryColor);
                                }
                              },
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: HuddleButton(
                          text: 'Add project',
                          onPressed: () { },
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
