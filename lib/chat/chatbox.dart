import 'package:BetSlipCode/chat/messagewall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBox extends StatefulWidget {
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final DateTime now = DateTime.now();
  var stream = FirebaseFirestore.instance.collection('chat_messages');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ChatBox'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // _alert();
              },
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            _alert();
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: stream
                      // .where('date', isEqualTo: date)

                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isEmpty) {
                        return Center(
                          child: Text('No messages yet for today'),
                        );
                      }
                      return MessageWall(messages: snapshot.data.docs);
                    }
                    return Center(
                      child: Text('loading'),
                    );
                  },
                ),
              ),
              MessageWall().textspace()
            ],
          ),
        ),
      ),
    );
  }

  _logout() async {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop();
  }

  _alert() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Leave Chat?'),
              content: Text('Are you sure you want to leave the chat room?'),
              actions: [
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    _logout();
                  },
                ),
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
