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
  final TextEditingController _controller = TextEditingController();
  String _message;
  final DateTime now = DateTime.now();
  var stream = FirebaseFirestore.instance.collection('chat_messages');

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('yyyy-MM-dd').format(now);
    return ListView.builder(
      controller: listKey,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final data = messages[index].data();
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.uid == data['author_id']) {
          return Dismissible(
            confirmDismiss: (DismissDirection direction) async {
              return await _deleteAlert(context, messages[index].id);
            },
            key: ValueKey(data['timestamp']),
            child: ChatMessage(
              index: index,
              data: data,
            ),
          );
        } else {
          return ChatMessageOther(
            index: index,
            data: data,
            showAvatar: shouldShowAvatar(index),
          );
        }
      },
    );
  }

  textspace() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              // focusNode: ,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                // border: ,
                icon: Icon(Icons.keyboard),
                hintText: 'Type a message',
                // focusedBorder:
                //     UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              onChanged: (text) {
                _message = text;
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _send();
            },
          ),
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

  void _addMessage(String value) async {
    final String date = DateFormat('yyyy-MM-dd').format(now);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await stream.add({
        'author': user.displayName ?? 'Anonymous',
        'author_id': user.uid,
        'photo_url': user.photoURL ?? 'https://placeholder.com/150',
        'value': value,
        'timestamp': Timestamp.now().toDate(),
        'date': date
      });
    }
    // listKey.jumpTo(listKey.position.maxScrollExtent);
  }

  _deleteMessage(String messageID) async {
    var stream = FirebaseFirestore.instance.collection('chat_messages');
    await stream.doc(messageID).delete();
  }

  _deleteAlert(BuildContext context, String messageID) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete Message'),
              content: Text('Are you sure you want to delete the message?'),
              actions: [
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    _deleteMessage(messageID);
                    Navigator.of(context).pop(true);
                  },
                ),
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            ));
  }

  bool shouldShowAvatar(int indx) {
    if (indx == 0) return true;
    final previousID = messages[indx - 1].data()['author_id'];
    final authorID = messages[indx].data()['author_id'];
    return authorID != previousID;
  }
}
