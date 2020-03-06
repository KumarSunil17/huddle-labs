import 'package:flutter/material.dart';

class HuddleScaffold extends StatefulWidget {
  final Widget body;
  final SnackbarPosition snackbarPosition;
  const HuddleScaffold(this.body,
      {Key key, this.snackbarPosition = SnackbarPosition.bottomLeft})
      : super(key: key);

  @override
  HuddleScaffoldState createState() => HuddleScaffoldState();
}

class HuddleScaffoldState extends State<HuddleScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  showErrorSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content:
          Text(message, style: TextStyle(inherit: true, color: Colors.black)),
    ));
  }

  showSuccessSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.lightGreenAccent,
      content:
          Text(message, style: TextStyle(inherit: true, color: Colors.black)),
    ));
  }

  showWarningSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.orangeAccent,
      content:
          Text(message, style: TextStyle(inherit: true, color: Colors.black)),
    ));
  }

  showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: widget.body,
          ),
          Positioned(
            bottom: 15,
            left: 15,
            height: 100,
            width: 350,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              key: _scaffoldKey,
            ),
          )
        ],
      ),
    );
  }
}

enum SnackbarPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  topCenter,
  bottomCenter
}
