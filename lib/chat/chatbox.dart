import 'package:BetSlipCode/chat/messagewall.dart';
import 'package:BetSlipCode/chat/publicslip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final String currentDate = DateFormat('yyyy-MM-dd').format(now);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ChatBox'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.more),
              onPressed: () {
                return Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PublicCodes()));
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
                  stream: stream.
                  where('date', isEqualTo: currentDate)
                  .orderBy('timestamp')
                  .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isEmpty) {
                        return Center(
                          child: Text('No messages yet for today'),
                        );
                      }
                      return MessageWall(messages: snapshot.data.docs, messagesLength: snapshot.data.docs.length);
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
