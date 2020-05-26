import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/login/login_page.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_alert.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:huddlelabs/utils/enums.dart';
import 'dart:html' as html;

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 350,
          margin: const EdgeInsets.all(kToolbarHeight),
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: StreamBuilder<DocumentSnapshot>(
              stream: usersCollection.doc(fb.auth().currentUser.uid).onSnapshot,
              builder: (context, s) {
                if (s.hasError)
                  return HuddleErrorWidget(message: '${s.error.toString()}');
                if (s.hasData)
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Stack(
                          children: <Widget>[
                            if (isLoading)
                              Positioned.fill(
                                  child: CircularProgressIndicator()),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Material(
                                  color: Colors.white,
                                  elevation: 8,
                                  shadowColor: Colors.red,
                                  clipBehavior: Clip.antiAlias,
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: isLoading ? 0 : 3)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.png',
                                    image: s.data.data()['photo'] ?? '',
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: 150,
                                  )
                                  // Image.network(
                                  //     s.data.data().containsKey('photo') &&
                                  //             s.data
                                  //                 .data()['photo']
                                  //                 .toString()
                                  //                 .isNotEmpty
                                  //         ? '${s.data.data()['photo']}'
                                  //         : s.data.data()['gender'] ==
                                  //                 Gender.male.toInt
                                  //             ? MALE_PLACEHOLDER
                                  //             : FEMALE_PLACEHOLDER,
                                  //     fit: BoxFit.cover,
                                  //     height: 150,
                                  //     width: 150)
                                  ),
                            ),
                            Positioned(
                                right: 8,
                                bottom: 8,
                                height: 36,
                                width: 36,
                                child: FloatingActionButton(
                                  onPressed: uploadImage,
                                  elevation: 0,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Icon(Icons.add_a_photo, size: 16),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      Text('${s.data.data()['name']}',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 22)),
                      SizedBox(
                        height: 8,
                      ),
                      Text('${s.data.data()['email']}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(
                        height: 2,
                      ),
                      Text('${s.data.data()['phone']}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 32),
                      HuddleOutlineButton('Logout', () {
                        showGeneralDialog(
                            barrierDismissible: true,
                            barrierLabel: 'logout-dialog',
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                scale: a1.value,
                                child:
                                    Opacity(opacity: a1.value, child: widget),
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
                                  positiveText: 'Ok');
                            });
                      }),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () {},
                            child: Text(
                              'Privacy policy',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Text('.'),
                          FlatButton(
                            onPressed: () {},
                            child: Text('Terms and Conditions',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  );
                else
                  return HuddleLoader(
                    color: Theme.of(context).primaryColor,
                  );
              },
            ),
          ),
        ),
      ),
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
      usersCollection
          .doc(fb.auth().currentUser.uid)
          .update(data: {'photo': uri.toString()}).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }
}
