import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'dart:html' as html;

class OtherProfileWidget extends StatelessWidget {
  final String userId;
  const OtherProfileWidget(this.userId);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 350,
          margin: const EdgeInsets.all(kToolbarHeight),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: StreamBuilder<DocumentSnapshot>(
              stream: usersCollection.doc(userId).onSnapshot,
              builder: (context, s) {
                if (s.hasError)
                  return HuddleErrorWidget(message: '${s.error.toString()}');
                if (s.hasData)
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                            child: HuddleCloseButton(),
                          )),
                      Material(
                        type: MaterialType.circle,
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: s.data.data()['photo'] ?? '',
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
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
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              html.window.open(
                                  'mailTo:${s.data.data()['email']}', 'Email');
                            },
                            color: Colors.red,
                            icon: Icon(Icons.email),
                          ),SizedBox(width:16),
                          IconButton(
                            onPressed: () {
                              html.window.open(
                                  'tel:${s.data.data()['phone']}', 'Phone');
                            },
                            color: Colors.blue,
                            icon: Icon(Icons.call),
                          ),
                        ],
                      ),
                      SizedBox(height: 16)
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
}
