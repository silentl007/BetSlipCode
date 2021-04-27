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
        if (user != null && user.uid == data['author_id']) {
          return ChatMessage(
            index: index,
            data: data,
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
}
