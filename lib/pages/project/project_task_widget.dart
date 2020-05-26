import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/constants.dart';

class TaskWidget extends StatelessWidget {
  final String title;
  final int status;
  final String projectId;
  final VoidCallback onAddTask;
  const TaskWidget({this.onAddTask, this.title, this.status, this.projectId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffEBECF0),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title', style: TextStyle(fontSize: 16, color: Colors.black)),
          StreamBuilder<QuerySnapshot>(
            stream: taskCollection.onSnapshot,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                QuerySnapshot tasksQuery = snapshot.data;
                List<DocumentSnapshot> tasks = [];
                tasksQuery.docs.forEach((element) {
                  if(element.data()['projectId'] == projectId){
                    if(element.data()['status'] == status){
                      tasks.add(element);
                    }
                  }
                });
                if(tasks.isNotEmpty){
                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      shrinkWrap: true,
                      itemCount: tasks.length, //tasks.length,
                      itemBuilder: (c, index) => TaskCard(tasks[index]));
                }else{
                  return Container();
                }
              }else{
                return Container();
              }
            }
          ),
          Row(
            children: [
              Expanded(
                child: RaisedButton.icon(
                    color: Colors.transparent,
                    elevation: 0,
                    disabledElevation: 0,
                    highlightElevation: 0,
                    onPressed: onAddTask,
                    icon: Icon(Icons.add),
                    label: Text('Add task')),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final DocumentSnapshot doc;
  const TaskCard(this.doc);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('${doc.data()['name']}')
                    Text('${doc.data()['title']}'),
                    Row(children: [
                      Material(
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text('Deadline: '+_getDeadLine(doc.data()['expiresAt'])),
                        ),
                      ),
                      Spacer(),
                      StreamBuilder<DocumentSnapshot>(
                        stream: usersCollection.doc(doc.data()['assignedTo']).onSnapshot,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Tooltip(
                              message: '${snapshot.data.data()['name']}',
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xfffDFE1E6),
                                child: Text(
                                  '${snapshot.data.data()['name'].toString()[0]}',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ),
                            );
                          }else{
                            return Container();
                          }
                        }
                      )
                    ])
                  ])),
        ));
  }

  String _getDeadLine(String deadLine) {
    DateTime _dueDate = DateTime.parse(deadLine);
    String weekDay = _getWeekDay(weekDayInInt: _dueDate.weekday);
    String month = _getMonth(month: _dueDate.month);
    String daySuffix = _getDaySuffix(_dueDate.day);
    String dateStr = weekDay + ', ' + _dueDate.day.toString() + daySuffix +
        ' ' + month + ' ' + _dueDate.year.toString();
    return dateStr;
  }

  String _getDaySuffix(int day){
    if(day == 1 || day == 11 || day == 21 || day == 31){
      return 'st';
    }else if(day == 2 || day == 12 || day == 22){
      return 'nd';
    }else{
      return 'th';
    }
  }

   String _getWeekDay({@required int weekDayInInt}){
    switch(weekDayInInt){
      case 1:
        return 'Mon';
        break;
      case 2:
        return 'Tue';
        break;
      case 3:
        return 'Wed';
        break;
      case 4:
        return 'Thu';
        break;
      case 5:
        return 'Fri';
        break;
      case 6:
        return 'Sat';
        break;
      case 7:
        return 'Sun';
        break;
      default:
        return '';
        break;
    }
  }

  String _getMonth({@required int month}){
    switch(month){
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
      default:
        return '';
        break;
    }
  }
}
