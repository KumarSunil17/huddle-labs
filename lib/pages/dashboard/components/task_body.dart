import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart'  as fb;
import 'package:huddlelabs/utils/components/error_widget.dart';

class TaskBody extends StatefulWidget {
  final String taskId, uid;
  const TaskBody(this.taskId, this.uid);

  @override
  _TaskBodyState createState() => _TaskBodyState();
}

class _TaskBodyState extends State<TaskBody> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      height: double.infinity,
      width: size.width - size.width / 4.5,padding: const EdgeInsets.all(50),
      child: StreamBuilder<DocumentSnapshot>(
        stream: fb.firestore().collection('tasks').doc(widget.taskId).onSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasError) return HuddleErrorWidget(message:'${snapshot.error}');
          if (snapshot.hasData) {
            DocumentSnapshot docData = snapshot.data;
            
            return Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${docData.data()['name']}', style: textTheme.headline5.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Colors.black54)),
                Text('${docData.data()['description']}', style: textTheme.headline6.copyWith(letterSpacing: 0.3, color: Colors.black87),),
                Text('${docData.data()['deadline']}'),
                Text('${docData.data()['status']}'),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
