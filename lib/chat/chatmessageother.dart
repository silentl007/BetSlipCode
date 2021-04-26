import 'package:flutter/material.dart';

class ChatMessageOther extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  ChatMessageOther({this.index, this.data});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double maxWidth300 = size.height * 0.3755;
    double padding10 = size.height * 0.01251;
    double padding12 = size.height * 0.015;
    double padding6 = size.height * 0.0075;
    double font12 = size.height * 0.015;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: padding12, vertical: padding6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(data['photo_url']),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
