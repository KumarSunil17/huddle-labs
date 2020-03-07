import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';
import 'package:firebase/firebase.dart' as fb;

class ProfileDrawer extends StatelessWidget {
  final String uid;
  static const String routeName = '/profile';
  ProfileDrawer(this.uid);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: fb.firestore().collection('user').doc(uid).onSnapshot,
          builder:(context, snapshot){
            return Container(
        width: 500,
        height: size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
            color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            EditableImage('https://img.icons8.com/bubbles/300/000000/google-logo.png',(){}),
            EditableField(
                'James Bond',
                TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    letterSpacing: 1.3),
                (value) {}),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfileAchivement(
                  text: 'Projects',
                  count: 12,
                ),
                ProfileAchivement(
                  text: 'Tasks completed',
                  count: 45,
                ),
              ],
            ),
            EditableField('1234567890', TextStyle(fontSize: 20), (value) {}),
            HuddleOutlineButton('Logout', () {})
          ],
        ),
      );
          },
    );
  }
}

class ProfileAchivement extends StatelessWidget {
  final String text;
  final int count;
  const ProfileAchivement({this.text = '', this.count = 0});

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

class EditableImage extends StatelessWidget {
  final String path;
  final VoidCallback onEdit;
  const EditableImage(this.path, this.onEdit);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        children: <Widget>[
          Material(
              color: Colors.white,
              elevation: 8,
              shadowColor: Colors.red,
              type: MaterialType.circle,
              child: Image.network(path, height: 200, width: 200)),
          Positioned(
              right: 8,
              bottom: 8,
              height: 50,
              width: 50,
              child: FloatingActionButton(
                onPressed: onEdit,
                backgroundColor: Colors.blue,
                child: Icon(Icons.edit, size: 20),
              ))
        ],
      ),
    );
  }
}

class EditableField extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function(String) onEditComplete;
  const EditableField(this.text, this.style, this.onEditComplete);

  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool isEditMode = false;
  TextEditingController textController;
  final FocusNode focusNode = FocusNode(canRequestFocus: true);
  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.unfocus();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Row(
            mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
      Text(
        widget.text,
        style: widget.style,
      ),
      SizedBox(width: 10),
      IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            focusNode.requestFocus();
            setState(() {
              isEditMode = true;
            });
          })
    ]);
    final editWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 200,
                  child: TextField(
            focusNode: focusNode,
            controller: textController,
            style: widget.style,
          ),
        ),
        SizedBox(width: 10),
        IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              focusNode.unfocus();
              setState(() {
                isEditMode = false;
              });
              widget.onEditComplete(textController.text.trim());
            })
      ],
    );
    return Align(
      alignment: Alignment.center,
          child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: isEditMode ? editWidget : textWidget,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
