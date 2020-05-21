import 'package:flutter/material.dart';
import 'package:huddlelabs/pojo/user.dart';
import 'package:huddlelabs/utils/constants.dart';

class HuddleSmallProfile extends StatefulWidget {
  final User user;
  const HuddleSmallProfile(this.user);

  @override
  _HuddleSmallProfileState createState() => _HuddleSmallProfileState();
}

class _HuddleSmallProfileState extends State<HuddleSmallProfile>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        lowerBound: 100,
        upperBound: 300)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
            type: MaterialType.circle,
            color: Colors.white,
            child: MouseRegion(
                onHover: (e) {
                  Navigator.push(
                      context,
                      PopupMenuRoute(
                          position: RelativeRect.fromLTRB(e.localPosition.dx,
                              e.localPosition.dy, 0, 0),
                          child: SmallProfileWidget(widget.user)));
                },
                onExit: (e) {
                  // Navigator.pop(context);
                },
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                      widget.user.dpUrl != null && widget.user.dpUrl.isNotEmpty
                          ? '${widget.user.dpUrl}'
                          : widget.user.gender == 'Male'
                              ? MALE_PLACEHOLDER
                              : FEMALE_PLACEHOLDER,
                      fit: BoxFit.cover),
                ))));
  }
}

class PopupMenuRoute extends PopupRoute {
  PopupMenuRoute({this.position, this.child});
  final Widget child;
  final RelativeRect position;
  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.easeIn,
      reverseCurve: const Interval(0.0, 500),
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => 'mini-profile';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: PopupMenuRouteLayout(
              position,
            ),
            child: Card(elevation: 3, child: child),
          );
        },
      ),
    );
  }
}

class PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  PopupMenuRouteLayout(this.position);

  final RelativeRect position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(
      constraints.biggest - const Offset(8 * 2.0, 8 * 2.0) as Size,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double y = position.top - 180;
    double x = position.left - 120;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class SmallProfileWidget extends StatefulWidget {
  final User user;
  SmallProfileWidget(this.user);

  @override
  _SmallProfileWidgetState createState() => _SmallProfileWidgetState();
}

class _SmallProfileWidgetState extends State<SmallProfileWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SmallProfileAnimator animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );
    animation = SmallProfileAnimator(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return SizedBox.fromSize(
      size: Size(280, 170),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ),
        Positioned(
            top: 75,
            left: 16,
            right: 16,
            child: Text('${widget.user.name}',
                style: TextStyle(
                  color: Colors.black.withOpacity(animation.nameOpacity.value),
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ))),
        Positioned(
          top: 90,
          left: 16,
          right: 16,
          child: Text(
            '${widget.user.location}',
            style: TextStyle(
              color: Colors.black.withOpacity(animation.locationOpacity.value),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Positioned(
          top: 105,
          left: 16,
          child: Container(
            color: Colors.black.withOpacity(0.85),
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: animation.dividerWidth.value,
            height: 1.0,
          ),
        ),
        Positioned(
          top: 130,
          left: 16,
          right: 16,
          child: Text('${widget.user.about}',
              style: TextStyle(
                color:
                    Colors.black.withOpacity(animation.biographyOpacity.value),
                height: 1.4,
              )),
        ),
        Positioned(left: 16, top: 16, child: _buildAvatar()),
      ],
    );
  }

/*
  if (animation.controller.status == AnimationStatus.completed) {
          animation.controller.reverse();
        } else if (animation.controller.status == AnimationStatus.dismissed) {
          animation.controller.forward();
        }
 */
  Widget _buildAvatar() {
    return Container(
        width: 50.0,
        height: 50.0,
        transform: Matrix4.diagonal3Values(
          animation.avatarSize.value,
          animation.avatarSize.value,
          1.0,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 1.5,
              )
            ]),
        child: Image.network(
            widget.user.dpUrl != null && widget.user.dpUrl.isNotEmpty
                ? '${widget.user.dpUrl}'
                : widget.user.gender == 'Male'
                    ? MALE_PLACEHOLDER
                    : FEMALE_PLACEHOLDER,
            fit: BoxFit.cover));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation.controller,
      builder: _buildAnimation,
    );
  }
}

class SmallProfileAnimator {
  SmallProfileAnimator(this.controller)
      : avatarSize = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.100,
              0.400,
              curve: Curves.elasticOut,
            ))),
        nameOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.350,
              0.450,
              curve: Curves.easeIn,
            ))),
        locationOpacity = Tween(begin: 0.0, end: 0.85).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.500,
              0.600,
              curve: Curves.easeIn,
            ))),
        dividerWidth = Tween(begin: 0.0, end: 225.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.650,
              0.750,
              curve: Curves.fastOutSlowIn,
            ))),
        biographyOpacity = Tween(begin: 0.0, end: 0.85).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.750,
              0.900,
              curve: Curves.easeIn,
            )));
  final AnimationController controller;
  final Animation<double> avatarSize;
  final Animation<double> nameOpacity;
  final Animation<double> locationOpacity;
  final Animation<double> dividerWidth;
  final Animation<double> biographyOpacity;
}
