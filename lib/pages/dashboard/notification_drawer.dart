import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/project/project_details_page.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/components/huddle_route_animation.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:intl/intl.dart';

class NotificationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
            title: Text('Alerts'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ],
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: notificationCollection.onSnapshot,
            builder: (c, s) {
              if (s.hasError)
                return HuddleErrorWidget(message: '${s.error.toString()}');
              if (s.hasData) {
                final List<DocumentSnapshot> data = s.data.docs
                    .where((element) =>
                        element.data()['userId'] == fb.auth().currentUser.uid)
                    .toList();
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (c, i) {
                    if (data[i].data()['read'] == false) {
                      return NotificationCard.active(data[i]);
                    } else {
                      return NotificationCard(data[i]);
                    }
                  },
                );
              }
              return HuddleLoader(
                color: Theme.of(context).primaryColor,
              );
            },
          ))
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final DocumentSnapshot notification;
  final bool isActive;
  const NotificationCard(this.notification) : isActive = false;
  const NotificationCard.active(this.notification) : isActive = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isActive
              ? BorderSide(color: Colors.red, width: 1.2)
              : BorderSide.none),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          notificationCollection
              .doc(notification.id)
              .update(data: {'read': true});
          if (notification.data()['projectId'] == null ||
              notification.data()['projectId'].toString().isEmpty) {
            showSnackbar('You have no access to this project.', context);
          } else
            Navigator.push(
                context,
                FadeRoute(
                    page:
                        ProjectDetailsPage(notification.data()['projectId'])));
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (notification.data()['projectId'].isNotEmpty)
                    StreamBuilder<DocumentSnapshot>(
                      stream: projectCollection
                          .doc(notification.data()['projectId'])
                          .onSnapshot,
                      builder: (c, s) => Text(
                        s.hasData ? s.data.data()['name'] : '',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  Text(
                      '${DateFormat('dd MMM yyyy').format(DateTime.parse(notification.data()['createdAt']))}',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 6),
              Text(
                '${notification.data()['text']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
