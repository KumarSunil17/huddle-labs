import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/components/huddle_loader.dart';

class HuddleButton extends StatefulWidget {
  final String text;
  final double height, width;
  final VoidCallback onPressed;
  HuddleButton(
      {Key key, this.text, this.onPressed, this.height = 50, this.width})
      : super(key: key);

  @override
  HuddleButtonState createState() => HuddleButtonState();
}

class HuddleButtonState extends State<HuddleButton> {
  bool _isLoading = false;

  showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      onPressed: _isLoading ? () {} : widget.onPressed,
      child: _isLoading
          ? Center(
              child: HuddleLoader(
              color: Colors.white,
              size: 40,
            ))
          : Text(
              widget.text,
              style: TextStyle(inherit: true, fontSize: 18),
            ),
      elevation: 2,
      minWidth: widget.width,
      color: Theme.of(context).buttonColor,
      hoverElevation: 0,
      highlightElevation: 3,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              topLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
    );
  }
}

class HuddleOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  HuddleOutlineButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: onPressed,
      borderSide: BorderSide(width: 5, color: Theme.of(context).primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Text(text, style: TextStyle(inherit: true, fontSize: 18)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              topLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
    );
  }
}

class HuddleCloseButton extends StatefulWidget {
  @override
  _HuddleCloseButtonState createState() => _HuddleCloseButtonState();
}

class _HuddleCloseButtonState extends State<HuddleCloseButton>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.maybePop(context);
      },
      child: MouseRegion(
        child: RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 0.5).animate(CurvedAnimation(
                parent: rotationController,
                curve: Interval(
                  0.0,
                  0.800,
                  curve: Curves.fastOutSlowIn,
                ))),
            child: Container(child: Icon(Icons.close, size: 50))),
        onHover: (e) {
          rotationController.forward();
        },
        onExit: (e) {
          rotationController.reverse();
        },
      ),
    );
  }
}
