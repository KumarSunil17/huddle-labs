import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/dashboard/add_project_dialog.dart';
import 'package:huddlelabs/pages/login/login_page.dart';
import 'package:huddlelabs/utils/components/empty_widget.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_alert.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'dart:html' as html;

class ProfileDrawer extends StatefulWidget {
  static const String routeName = '/profile';
  final String selectedProjectId;
  final Function(String projectId) onProjectSelect;
  const ProfileDrawer(this.selectedProjectId, this.onProjectSelect);
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  double progressPercentage = 0;
  bool isLoading = false;
  final uid = fb.auth().currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: fb.firestore().collection('users').doc(uid).onSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final DocumentSnapshot document = snapshot.data;
          return Drawer(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                isLoading ? LinearProgressIndicator() : Container(),
                SizedBox(
                  height: 22,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    children: <Widget>[
                      Material(
                          color: Colors.white,
                          elevation: 12,
                          shadowColor: Colors.red,
                          shape: CircleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3)),
                          child: Image.network(
                              document.data().containsKey('dp') &&
                                      document
                                          .data()['dp']
                                          .toString()
                                          .isNotEmpty
                                  ? '${document.data()['dp']}'
                                  : document.data()['gender'] == 'Male'
                                      ? MALE_PLACEHOLDER
                                      : FEMALE_PLACEHOLDER,
                              fit: BoxFit.fill,
                              height: 200,
                              width: 200)),
                      Positioned(
                          right: 8,
                          bottom: 8,
                          height: 36,
                          width: 36,
                          child: FloatingActionButton(
                            onPressed: uploadImage,
                            elevation: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(Icons.add_a_photo, size: 16),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Text('${document.data()['name']}',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 1.3)),
                Text(
                  '${document.data()['phone']} . ${document.data()['email']}',
                ),
                SizedBox(
                  height: 12,
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    'PROJECTS',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.2),
                  ),
                  trailing: IconButton(
                    tooltip: 'Add project',
                    onPressed: () {
                      showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: 'add-project-dialog',
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
                            return AddProjectDialog();
                          });
                    },
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: fb.firestore().collection('projects').onSnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return HuddleErrorWidget(message: '${snapshot.error}');

                      if (snapshot.hasData) {
                        List<DocumentSnapshot> resultList = snapshot.data.docs;

                        if (resultList.isEmpty)
                          return const HuddleEmptyWidget(
                            message: 'You have no projects.',
                          );

                        return ListView.builder(
                          itemCount: resultList.length,
                          itemBuilder: (ctx, index) {
                            return ColoredBox(
                              color: widget.selectedProjectId ==
                                      resultList[index].id
                                  ? Colors.grey.withOpacity(0.2)
                                  : Colors.transparent,
                              child: ListTile(
                                selected: widget.selectedProjectId ==
                                    resultList[index].id,
                                onTap: () => widget
                                    .onProjectSelect(resultList[index].id),
                                title:
                                    Text('${resultList[index].data()['name']}'),
                              ),
                            );
                          },
                        );
                      } else {
                        return HuddleLoader(
                            color: Theme.of(context).primaryColor);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                HuddleOutlineButton('Logout', () {
                  showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: 'logout-dialog',
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
                        return HuddleAlert(
                          positiveAction: () {
                            return fb.auth().signOut().then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  FadeRoute(page: LoginPage()),
                                  (route) => false);
                            });
                          },
                          alertTitle: 'Logout',
                          completedTitle: 'You have been logged out.',
                          loadingTitle: 'Please wait',
                          negativeText: 'Cancel',
                          positiveText: 'Ok',
                        );
                      });
                }),
                SizedBox(
                  height: 22,
                ),
              ],
            ),
          );
        } else {
          return Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  uploadImage() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = false;
    uploadInput.accept = 'image/png,image/jpeg,image/jpg';
    uploadInput.click();

    uploadInput.onChange.listen(
      (changeEvent) {
        final file = uploadInput.files.first;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen(
          (loadEndEvent) async {
            uploadToFirebase(file);
          },
        );
      },
    );
  }

  uploadToFirebase(html.File imageFile) async {
    setState(() {
      isLoading = true;
    });
    final fb.UploadTask task = fb
        .storage()
        .ref('users_dp/${fb.auth().currentUser.uid}.jpg')
        .put(imageFile);
    final snapshot = await task.future;
    snapshot.ref.getDownloadURL().then((uri) {
      fb
          .firestore()
          .collection('users')
          .doc(fb.auth().currentUser.uid)
          .update(data: {'dp': uri.toString()}).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }
}

class ProfileAchievement extends StatelessWidget {
  final String text;
  final int count;
  const ProfileAchievement({this.text = '', this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset('assets/Polygon.png'),
              ),
              Positioned.fill(
                  child: Center(
                      child: Text(
                '$count',
                style: TextStyle(
                    inherit: true,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3),
              )))
            ],
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1.3,
          ),
        )
      ],
    );
  }
}
