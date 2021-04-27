import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  ChatMessage({this.data, this.index});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double maxWidth300 = size.height * 0.3755;
    double padding10 = size.height * 0.01251;
    double padding12 = size.height * 0.015;
    double padding6 = size.height * 0.0075;
    double font12 = size.height * 0.015;
    double size40 = size.height * 0.05;
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: padding10,
            right: padding10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: padding10,
            vertical: padding12,
          ),
          constraints: BoxConstraints(maxWidth: maxWidth300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(data['value']),
        ),
      ],
    ));
  }
}