import 'package:flutter/material.dart';

typedef PositiveCallback = Future Function();
enum _DialogMode { alert, loading, completed }

class HuddleAlert extends StatefulWidget {
  final String alertTitle,
      loadingTitle,
      completedTitle,
      positiveText,
      negativeText;
  final PositiveCallback positiveAction;
  HuddleAlert(
      {this.positiveText = 'Ok',
      @required this.positiveAction,
      this.negativeText = 'Cancel',
      this.alertTitle = 'Are you sure want to perform this action?',
      this.completedTitle = 'Successful',
      this.loadingTitle = 'Loading'});

  @override
  _HuddleDialogState createState() => _HuddleDialogState();
}

class _HuddleDialogState extends State<HuddleAlert> {
  _DialogMode mode = _DialogMode.alert;
  String completedText;
  @override
  void initState() {
    super.initState();
    completedText = widget.completedTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        if (mode == _DialogMode.alert) {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('${widget.alertTitle}'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('${widget.negativeText}'),
                textColor: Colors.blue,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    mode = _DialogMode.loading;
                  });
                  final Future positiveResult = widget.positiveAction();
                  if (positiveResult == null) return;
                  positiveResult.then((result) {
                    if (mounted) {
                      setState(() {
                        completedText = widget.completedTitle;
                        mode = _DialogMode.completed;
                      });
                      Future.delayed(Duration(milliseconds: 1500))
                          .then((value) => Navigator.pop(context, false));
                    }
                  }).catchError((error) {
                    setState(() {
                      completedText = error.toString();
                      mode = _DialogMode.completed;
                    });
                    Future.delayed(Duration(milliseconds: 1500))
                        .then((value) => Navigator.pop(context, false));
                  });
                },
                child: Text('${widget.positiveText}'),
                textColor: Colors.blue,
              ),
            ],
          );
        } else if (mode == _DialogMode.loading) {
          return AlertDialog(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text(
                    "${widget.loadingTitle}"
                  )
                ],
              ));
        } else {
          return AlertDialog(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('$completedText'),
          );
        }
      },
    );
  }
}
