import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  ChatMessage({this.data, this.index});
  var format = DateFormat('HH:mm a');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double maxWidth300 = size.height * 0.3755;
    double padding10 = size.height * 0.01251;
    double padding12 = size.height * 0.015;
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
            // color: Colors.blue
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(data['value']),
              Text(format.format(data['timestamp'].toDate()), style: TextStyle(fontSize: padding10),),
            ],
          ),
        ),
      ],
    ));
  }
}
