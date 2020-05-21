import 'package:flutter/material.dart';

class HuddleErrorWidget extends StatelessWidget {
  final String message;
  const HuddleErrorWidget({this.message="Error occurred"});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.headline6,),
    );
  }
}