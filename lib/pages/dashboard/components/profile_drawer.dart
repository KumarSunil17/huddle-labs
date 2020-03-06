import 'package:flutter/material.dart';
import 'package:huddlelabs/utils/components/huddle_button.dart';

class ProfileDrawer extends StatelessWidget {
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
        child: Drawer(
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://img.icons8.com/bubbles/300/000000/google-logo.png'),
                backgroundColor: Colors.transparent,
              ),
              Text('James Bond', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: 1.3)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HuddleAchivement(
                    text: 'Projects',
                    count: 12,
                  ),
                  HuddleAchivement(
                    text: 'Tasks completed',
                    count: 45,
                  ),
                ],
              ),HuddleOutlineButton('Logout', (){})
            ],
          ),
        ));
  }
}

class HuddleAchivement extends StatelessWidget {
  final String text;
  final int count;
  const HuddleAchivement({this.text = '', this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100,
          width: 100,
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
