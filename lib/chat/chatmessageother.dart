import 'package:code_realm/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatMessageOther extends StatelessWidget {
  final int? index;
  final Map<String, dynamic>? data;
  final bool showAvatar;
  ChatMessageOther({this.index, this.data, this.showAvatar = true});
  var format = DateFormat('HH:mm a');
  List<Color?> colorList = [
    Colors.blue,
    Colors.amber,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.indigo,
    Colors.pink,
    Colors.yellow,
    Colors.brown,
    Colors.teal,
    Colors.limeAccent,
    Colors.indigoAccent,
    Colors.deepOrange,
    Colors.blue[700],
    Colors.amber[700],
    Colors.purple[700],
    Colors.green[700],
    Colors.orange[700],
    Colors.indigo[700],
    Colors.pink[700],
    Colors.yellow[700],
    Colors.brown[700],
    Colors.teal[700],
    Colors.limeAccent[700],
    Colors.indigoAccent[700],
    Colors.deepOrange[700],
  ];
  List alphabets = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];
  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return Padding(
      padding: EdgeInsets.only(right: Sizes.w50),
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: Sizes.w12, vertical: Sizes.h12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showAvatar
                ? Padding(
                    padding: EdgeInsets.only(top: Sizes.h12),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data!['photo_url']),
                    ),
                  )
                : SizedBox(
                    width: Sizes.w40,
                  ),
            SizedBox(
              width: Sizes.w5,
            ),
            Container(
              width: Sizes.w250,
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.w10,
                vertical: Sizes.h12,
              ),
              constraints: BoxConstraints(maxWidth: Sizes.w300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data!['author']} said:',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: Sizes.w12,
                        color: colorDecider('${data!['author'].toString()[0]}'),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: Sizes.h5,
                  ),
                  Text(
                    data!['value'],
                    textAlign: TextAlign.justify,
                    style: TextStyle(height: 1.2, fontSize: Sizes.w15),
                  ),
                  Divider(height: Sizes.h3,),
                  Text(
                    format.format(data!['timestamp'].toDate()),
                    
                    style: TextStyle(fontSize: Sizes.w10, color: Colors.red),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  colorDecider(String letter) {
    print(alphabets.length);
    for (var i = 0; i <= alphabets.length - 1; i++) {
      if (letter.toLowerCase() == alphabets[i]) {
        return colorList[i];
      }
    }
  }
}
