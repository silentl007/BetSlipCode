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
  TextEditingController _controller = TextEditingController();
  String _message;
  final DateTime now = DateTime.now();

  var stream = FirebaseFirestore.instance.collection('chat_messages');

  void _addMessage(String value) async {
    final String date = DateFormat('yyyy-MM-dd').format(now);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await stream.add({
        'author': user.displayName ?? 'Anonymous',
        'author_id': user.uid,
        'photo_url': user.photoURL ?? 'https://placeholder.com/150',
        'value': value,
        'timestamp': Timestamp.now().millisecondsSinceEpoch,
        'date': date // date will be used for filtering to show only that day
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String date = DateFormat('yyyy-MM-dd').format(now);
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
              textspace()
            ],
          ),
        ),
      ),
    );
  }

  textspace() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type a message',
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              onChanged: (text) {
                _message = text;
              },
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: MaterialButton(
              child: Text('Send'),
              onPressed: () {
                _send();
              },
            ),
          )
        ],
      ),
    );
  }

  _send() {
    if (_message.isEmpty || _message == null) {
    } else {
      _addMessage(_message);
      _message = '';
      _controller.clear();
    }
  }

  _logout() async {
    Navigator.of(context).pop(true);
    // FirebaseAuth.instance.signOut();
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
