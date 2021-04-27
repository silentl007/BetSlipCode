import 'package:BetSlipCode/chat/chatmessage.dart';
import 'package:BetSlipCode/chat/chatmessageother.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/chat/messagewall.dart';

class MessageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  MessageWall(this.messages);

  bool shouldShowAvatar(int indx) {
    if (indx == 0) return true;
    final previousID = messages[indx - 1].data()['author_id'];
    final authorID = messages[indx].data()['author_id'];
    return authorID != previousID;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final data = messages[index].data();
        final user = FirebaseAuth.instance.currentUser;
        // use data['date'] == Date.Now() to filter to show only the day's message
        // if (---){}
        if (user != null && user.uid == data['author_id']) {
          return Dismissible(
            onDismissed: (_) {
              _deleteMessage(messages[index].id);
            },
            key: ValueKey(data['timestamp']),
            child: ChatMessage(
              index: index,
              data: data,
            ),
          );
        }
        return ChatMessageOther(
          index: index,
          data: data,
          showAvatar: shouldShowAvatar(index),
        );
      },
    );
  }

  _deleteMessage(String messageID) async {
    var stream = FirebaseFirestore.instance.collection('chat_messages');
    await stream.doc(messageID).delete();
  }
}
