import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase/firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:huddlelabs/utils/components/error_widget.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';
import 'package:huddlelabs/utils/constants.dart';
import 'package:huddlelabs/utils/enums.dart';
import 'package:firebase/firebase.dart' as fb;
import 'components/chat_message_widget.dart';
import 'components/other_files_widget.dart';

///
///Created By Sunil Kumar at 25/05/2020
///

class TaskConversationWidget extends StatefulWidget {
  final html.File file;
  final VoidCallback onRemoveFile, onChooseFile;
  final String taskId;
  final String userId;
  final bool isChatVisible, isChatExpired;
  const TaskConversationWidget(
      this.taskId, this.userId, this.file, this.onRemoveFile, this.onChooseFile,
      {this.isChatExpired = true, this.isChatVisible = true});
  @override
  _TaskConversationWidgetState createState() => _TaskConversationWidgetState();
}

class _TaskConversationWidgetState extends State<TaskConversationWidget> {
  Uint8List _bytesData;
  bool isFileSelected = false;
  FileType fileType;
  ScrollController scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    scrollController.dispose();
    _textEditingController..dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskConversationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file != null) {
      fileType = fromStringToFileType(widget.file.type);
      if (fileType == null) {
        ///invalid file
        setState(() {
          isFileSelected = false;
        });
      } else if (fileType == FileType.jpgImage ||
          fileType == FileType.pngImage) {
        final reader = html.FileReader();
        reader.readAsDataUrl(widget.file);
        reader.onLoadEnd.listen(
          (loadEndEvent) async {
            setState(() {
              _bytesData = Base64Decoder()
                  .convert(reader.result.toString().split(",").last);
              isFileSelected = true;
            });
          },
        );
      } else {
        setState(() {
          isFileSelected = true;
        });
      }
    } else {
      setState(() {
        isFileSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              elevation: 4,
              // color: Color(0xffcecece),
              child: StreamBuilder<DocumentSnapshot>(
                stream: usersCollection.doc(widget.userId).onSnapshot,
                builder: (c, userSnapshot) => userSnapshot.hasData
                    ? ListTile(
                        leading: Material(
                          type: MaterialType.circle,
                          color: Colors.grey.withOpacity(0.3),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: userSnapshot.data.data()['photo'] ?? '',
                            fit: BoxFit.cover,
                            height: 42,
                            width: 42,
                          ),
                        ),
                        title: Text('${userSnapshot.data.data()['name']}'),
                        trailing: HuddleCloseButton(),
                      )
                    : Container(),
              ),
            ),
            Expanded(
                child: ColoredBox(
              color: Colors.blue.withOpacity(0.1),
              child: StreamBuilder<QuerySnapshot>(
                stream: chatCollection
                    .where('taskId', '==', widget.taskId)
                    .orderBy('createdAt', 'desc')
                    .onSnapshot,
                builder: (c, chatSnapshot) {
                  if (chatSnapshot.hasError) print(chatSnapshot.error);
                  if (chatSnapshot.hasData) {
                    if (chatSnapshot.data.docs.isEmpty) {
                      return HuddleErrorWidget(
                        message:
                            'No conversations yet.',
                      );
                    } else {
                      return ListView.builder(
                        reverse: true,
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: chatSnapshot.data.docs.length,
                        itemBuilder: (c, i) {
                          final DocumentSnapshot chatDoc =
                              chatSnapshot.data.docs[i];
                          if (chatDoc.data()['sentBy'] ==
                              fb.auth().currentUser.uid) {
                            return ChatMessageWidget.sender(
                              dateTime: chatDoc.data()['createdAt'],
                              imageUrl: chatDoc.data()['attachment'],
                              message: chatDoc.data()['message'],
                              fileType:
                                  fromintToFileType(chatDoc.data()['fileType']),
                            );
                          } else {
                            return ChatMessageWidget.receiver(
                              dateTime: chatDoc.data()['createdAt'],
                              imageUrl: chatDoc.data()['attachment'],
                              message: chatDoc.data()['message'],
                              fileType:
                                  fromintToFileType(chatDoc.data()['fileType']),
                            );
                          }
                        },
                      );
                    }
                  } else {
                    return HuddleLoader(color: Theme.of(context).primaryColor);
                  }
                },
              ),
            )),
            ColoredBox(
              color: Colors.black12,
              child: widget.isChatExpired
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                        'Task is completed.',
                        style: TextStyle(fontSize: 16),
                    ),
                      ))
                  : widget.isChatVisible
                      ? Row(
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                            Tooltip(
                                message:
                                    'Click here to choose file or drag here a file.',
                                preferBelow: false,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(colors: [
                                    Color(0xff6a11cb),
                                    Color(0xff2575fc)
                                  ]),
                                ),
                                child: RawMaterialButton(
                                    onPressed: widget.onChooseFile,
                                    shape: CircleBorder(),
                                    constraints: BoxConstraints.tightFor(
                                        height: 42, width: 42),
                                    child: Transform.rotate(
                                        angle: -45 * pi / 180,
                                        child: Icon(Icons.attachment)))),
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8)),
                              ),
                            ),
                            RawMaterialButton(
                                onPressed: () {
                                  final message =
                                      _textEditingController.text.trim();
                                  if (widget.file == null && message.isEmpty) {
                                    showSnackbar(
                                        'Type a message or choose a file to send message.',
                                        context);
                                  } else {
                                    try {
                                      chatCollection.add({
                                        'taskId': widget.taskId,
                                        'message': message,
                                        'fileType': 0,
                                        'sentBy': fb.auth().currentUser.uid,
                                        'createdAt':
                                            DateTime.now().toIso8601String(),
                                      }).then((chatData) async {
                                        if (widget.file != null) {
                                          final Flushbar flushbar = Flushbar(
                                            message: "Uploading file",
                                            flushbarStyle:
                                                FlushbarStyle.FLOATING,
                                            margin: const EdgeInsets.all(16),
                                            animationDuration: const Duration(
                                                milliseconds: 400),
                                            maxWidth: 600,
                                            progressIndicatorValueColor:
                                                AlwaysStoppedAnimation(
                                                    Colors.white),
                                            progressIndicatorBackgroundColor:
                                                Colors.pink,
                                            showProgressIndicator: true,
                                            backgroundGradient: LinearGradient(
                                                colors: [
                                                  Color(0xff6a11cb),
                                                  Color(0xff2575fc)
                                                ]),
                                          );
                                          flushbar.show(context);
                                          final fb.UploadTask task = fb
                                              .storage()
                                              .ref(
                                                  'tasks_photo/${chatData.id + '_' + widget.file.name.replaceAll(' ', '_')}')
                                              .put(widget.file);
                                          final snapshot = await task.future;
                                          snapshot.ref
                                              .getDownloadURL()
                                              .then((uri) {
                                            chatData.update(data: {
                                              'attachment': uri.toString(),
                                              'fileType': fileType.toInt
                                            }).then((value) {
                                              widget.onRemoveFile();
                                              flushbar.dismiss();
                                            });
                                          });
                                        }
                                      }).whenComplete(() {
                                        _textEditingController.clear();
                                      });
                                    } catch (e) {
                                      if (e is PlatformException) {
                                        showSnackbar(e.message, context);
                                      } else if (e is fb.FirebaseError) {
                                        showSnackbar(e.message, context);
                                      } else {
                                        showSnackbar(e.toString(), context);
                                      }
                                    }
                                  }
                                },
                                shape: CircleBorder(),
                                constraints: BoxConstraints.tightFor(
                                    height: 42, width: 42),
                                child: Transform.rotate(
                                    angle: -45 * pi / 180,
                                    child: Icon(Icons.send)))
                          ],
                        )
                      : Container(),
            )
          ],
        ),
        Positioned.fill(
            top: 56,
            bottom: 48,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: kThemeChangeDuration,
                height: isFileSelected ? 600 : 0,
                width: double.infinity,
                child: Material(
                  color: Color(0xffeeeeee),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        iconSize: isFileSelected ? 24 : 0,
                        onPressed: widget.onRemoveFile,
                      ),
                      Spacer(flex: 1),
                      if (_bytesData != null)
                        Expanded(
                          flex: 3,
                          child: Center(
                              child: ChoosedFileWidget(fileType,
                                  image: _bytesData, name: widget.file?.name)),
                        ),
                      Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
