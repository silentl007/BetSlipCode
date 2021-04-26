import 'package:BetSlipCode/chat/chatmessageother.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/chat/messagewall.dart';

class MessageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  MessageWall(this.messages);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatMessageOther(index: index, data: messages[index].data());
      },
    );
  }
}
