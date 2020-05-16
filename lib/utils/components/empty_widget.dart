import 'package:flutter/material.dart';

class HuddleEmptyWidget extends StatelessWidget {
  final String message;
  const HuddleEmptyWidget({this.message='No data found.'});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.headline6),
    );
  }
}