import 'package:code_realm/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatMessage extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  ChatMessage({required this.data, required this.index});
  var format = DateFormat('HH:mm a');
  @override
  Widget build(BuildContext context) {
   Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
           width: Sizes.w250,
          margin: EdgeInsets.only(
            left: Sizes.w10,
            right: Sizes.w10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.w10,
            vertical: Sizes.h12,
          ),
          constraints: BoxConstraints(maxWidth: Sizes.w300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data['value'],
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.2, fontSize: Sizes.w15),
              ),Divider(height: Sizes.h3,),
              Text(
                format.format(data['timestamp'].toDate()),
                style: TextStyle(fontSize: Sizes.w10, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
