import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/pages/task/task_conversation_widget.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:huddlelabs/utils/enums.dart';
import 'package:intl/intl.dart';

class TaskDetailsDialog extends StatefulWidget {
  static const String routeName = '/taskDetailsDialog';
  final String taskId;
  const TaskDetailsDialog(this.taskId);
  @override
  _TaskDetailsDialogState createState() => _TaskDetailsDialogState();
}

class _TaskDetailsDialogState extends State<TaskDetailsDialog> {
  StreamSubscription<MouseEvent> _onDragOverSubscription;
  StreamSubscription<MouseEvent> _onDropSubscription;
  StreamSubscription<MouseEvent> _onDragLeaveSubscription;
  StreamSubscription<Event> _fileSelectionSubscription;
  final StreamController<_DragState> _dragStateStreamController =
      StreamController<_DragState>.broadcast();
  final StreamController<Point<double>> _pointStreamController =
      StreamController<Point<double>>.broadcast();
  FileUploadInputElement _inputElement;

  @override
  void dispose() {
    _onDropSubscription.cancel();
    _onDragOverSubscription.cancel();
    _onDragLeaveSubscription.cancel();
    _fileSelectionSubscription.cancel();
    _dragStateStreamController.close();
    _pointStreamController.close();
    super.dispose();
  }

  File _files;
  void _onDragOver(MouseEvent value) {
    value.stopPropagation();
    value.preventDefault();

    _pointStreamController.sink
        .add(Point<double>(value.layer.x.toDouble(), value.layer.y.toDouble()));
    _dragStateStreamController.sink.add(_DragState.dragging);
  }

  void _onDrop(MouseEvent value) {
    value.stopPropagation();
    value.preventDefault();
    _pointStreamController.sink.add(null);
    _addFiles(value.dataTransfer.files[0]);
  }

  void _onDragLeave(MouseEvent value) {
    this._dragStateStreamController.sink.add(_DragState.notDragging);
  }

  void _fileSelection(Event value) {
    _addFiles((value.target as FileUploadInputElement).files[0]);
  }

  void _addFiles(File newFiles) {
    this.setState(() {
      this._files = newFiles;
    });
  }

  @override
  void initState() {
    super.initState();
    this._onDragOverSubscription = document.body.onDragOver.listen(_onDragOver);
    this._onDropSubscription = document.body.onDrop.listen(_onDrop);
    this._onDragLeaveSubscription =
        document.body.onDragLeave.listen(_onDragLeave);
    this._inputElement = FileUploadInputElement()..style.display = 'none';
    _inputElement.multiple = false;
    _inputElement.accept = 'image/*';
    this._fileSelectionSubscription =
        this._inputElement.onChange.listen(_fileSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.all(54),
        useMaterialBorderRadius: true,
        child: StreamBuilder<DocumentSnapshot>(
          stream: taskCollection.doc(widget.taskId).onSnapshot,
          builder: (c, snapshot) => snapshot.hasData
              ? Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  TaskStatusWidget(
                                      status: snapshot.data.data()['status'],
                                      onStatusChanged: (snapshot.data.data()[
                                                          'assignedBy'] ==
                                                      fb
                                                          .auth()
                                                          .currentUser
                                                          .uid ||
                                                  snapshot.data.data()[
                                                          'assignedTo'] ==
                                                      fb
                                                          .auth()
                                                          .currentUser
                                                          .uid) &&
                                              snapshot.data.data()['status'] !=
                                                  TaskStatus.completed.toInt
                                          ? (i) {
                                              taskCollection
                                                  .doc(widget.taskId)
                                                  .update(data: {
                                                'status': i
                                              }).then((value) {
                                                usersCollection
                                                    .doc(fb
                                                        .auth()
                                                        .currentUser
                                                        .uid)
                                                    .get()
                                                    .then((currentUserDoc) {
                                                  String currentUserName =
                                                      currentUserDoc
                                                          .data()['name'];
                                                  transactionCollection.add({
                                                    'createdAt': DateTime.now()
                                                        .toIso8601String(),
                                                    'createdBy': fb
                                                        .auth()
                                                        .currentUser
                                                        .uid,
                                                    'message':
                                                        '$currentUserName changed ${snapshot.data.data()['title']} to ${taskStatusFromInt(i).toTaskString}',
                                                    'projectId': snapshot.data
                                                        .data()['projectId'],
                                                    'taskId': widget.taskId,
                                                  });
                                                });
                                              });
                                            }
                                          : null),
                                  SizedBox(width: 8),
                                  Tooltip(
                                    message: getDeadlineString(
                                        snapshot.data.data()['expiresAt']),
                                    preferBelow: false,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(colors: [
                                        Color(0xff6a11cb),
                                        Color(0xff2575fc)
                                      ]),
                                    ),
                                    child: Material(
                                        color: snapshot.data.data()['status'] ==
                                                TaskStatus.completed.toInt
                                            ? Color(0xff00cf00)
                                            : getDeadlineColor(snapshot.data
                                                .data()['expiresAt']),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('EEE, MMM d, yyyy')
                                                .format(DateTime.parse(snapshot
                                                    .data
                                                    .data()['expiresAt'])),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              Text('${snapshot.data.data()['title']}',
                                  style: Theme.of(context).textTheme.headline4),
                              SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                      '${snapshot.data.data()['description']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: TaskConversationWidget(
                          widget.taskId,
                          snapshot.data.data()['assignedBy'] ==
                                  fb.auth().currentUser.uid
                              ? snapshot.data.data()['assignedTo']
                              : snapshot.data.data()['assignedBy'],
                          this._files,
                          () {
                            setState(() {
                              this._files = null;
                            });
                          },
                          () {
                            this._inputElement.click();
                          },
                          isChatExpired: snapshot.data.data()['status'] ==
                              TaskStatus.completed.toInt,
                          isChatVisible: snapshot.data.data()['assignedBy'] ==
                                  fb.auth().currentUser.uid ||
                              snapshot.data.data()['assignedTo'] ==
                                  fb.auth().currentUser.uid,
                        )),
                      ],
                    ),
                    StreamBuilder(
                      initialData: null,
                      stream: this._pointStreamController.stream,
                      builder: (BuildContext context,
                              AsyncSnapshot<Point<double>> snapPoint) =>
                          (snapPoint.data == null ||
                                  snapPoint.data is! Point<double> ||
                                  snapPoint.data ==
                                      const Point<double>(0.0, 0.0))
                              ? Container()
                              : StreamBuilder(
                                  initialData: null,
                                  stream:
                                      this._dragStateStreamController.stream,
                                  builder: (BuildContext context,
                                          AsyncSnapshot<_DragState>
                                              snapState) =>
                                      (snapState.data == null ||
                                              snapState.data is! _DragState ||
                                              snapState.data ==
                                                  _DragState.notDragging)
                                          ? Container()
                                          : Positioned(
                                              width: 140,
                                              left: snapPoint.data.x - 115,
                                              top: snapPoint.data.y - 20,
                                              child: Column(
                                                children: [
                                                  const Icon(
                                                    Icons.file_upload,
                                                    size: 120,
                                                    color:
                                                        const Color(0xFFffa726),
                                                  ),
                                                  Text(
                                                    'Drop file to send',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )
                                                ],
                                              ),
                                            ),
                                ),
                    )
                  ],
                )
              : SizedBox.expand(
                  child: HuddleLoader(color: Theme.of(context).primaryColor),
                ),
        ));
  }
}

enum _DragState {
  dragging,
  notDragging,
}

class TaskStatusWidget extends StatelessWidget {
  final int status;
  final Function(int) onStatusChanged;
  const TaskStatusWidget({this.status, this.onStatusChanged});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(4),
                    right: onStatusChanged == null
                        ? Radius.circular(4)
                        : Radius.circular(0))),
            onPressed: () {},
            child: Text(
              '${taskStatusFromInt(status).toTaskString}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            color: getColor()),
        SizedBox(width: 2),
        onStatusChanged != null
            ? Tooltip(
                message: 'Proceed to next status',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                      colors: [Color(0xff6a11cb), Color(0xff2575fc)]),
                ),
                preferBelow: false,
                child: RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(4))),
                  constraints: BoxConstraints.tightFor(width: 36, height: 36),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  fillColor: getColor(),
                  onPressed: () => onStatusChanged(status + 1),
                  child: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Color getColor() {
    switch (status) {
      case 1:
        return Color(0xff384047); //created
      case 2:
        return Colors.blue; //progress
      case 3:
        return Colors.orange; //submitted
      case 4:
        return Colors.green; //completed
      default:
        return Colors.red;
    }
  }
}
