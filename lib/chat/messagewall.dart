import 'package:BetSlipCode/chat/chatmessage.dart';
import 'package:BetSlipCode/chat/chatmessageother.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  MessageWall({this.messages});
  final listKey = ScrollController();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  bool shouldShowAvatar(int indx) {
    if (indx == 0) return true;
    final previousID = messages[indx - 1].data()['author_id'];
    final authorID = messages[indx].data()['author_id'];
    return authorID != previousID;
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = formatter.format(now);
    return ListView.builder(
      // reverse: true,
      // shrinkWrap: true,
      controller: listKey,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final data = messages[index].data();
        final user = FirebaseAuth.instance.currentUser;
        // use data['date'] == Date.Now() to filter to show only the day's message
        // if (---){}
        if (data['date'].toString() == currentDate) {
          print('---------------------------------------');
          if (user != null && user.uid == data['author_id']) {
            // listKey.jumpTo(listKey.position.maxScrollExtent);
            print('-------------- chat message -------------------------');
            return ChatMessage(
              index: index,
              data: data,
            );
          } else {
            return ChatMessageOther(
              index: index,
              data: data,
              showAvatar: shouldShowAvatar(index),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  _deleteMessage(String messageID) async {
    var stream = FirebaseFirestore.instance.collection('chat_messages');
    await stream.doc(messageID).delete();
  }
}
