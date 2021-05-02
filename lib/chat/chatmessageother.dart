import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageOther extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  final bool showAvatar;
  ChatMessageOther({this.index, this.data, this.showAvatar = true});
  var format = DateFormat('HH:mm a');
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
      margin: EdgeInsets.symmetric(horizontal: padding12, vertical: padding6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            CircleAvatar(
              backgroundImage: NetworkImage(data['photo_url']),
            )
          else
            SizedBox(
              width: size40,
            ),
          SizedBox(
            width: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding10,
              vertical: padding12,
            ),
            constraints: BoxConstraints(maxWidth: maxWidth300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // color: Colors.black
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data['author']} said:',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: font12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(data['value']),
                Text(format.format(data['timestamp'].toDate()),style: TextStyle(fontSize: padding10),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
