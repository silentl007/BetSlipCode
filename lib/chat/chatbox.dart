import 'package:code_realm/chat/publicslip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:code_realm/chat/chatmessage.dart';
import 'package:code_realm/chat/chatmessageother.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatBox extends StatefulWidget {
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final DateTime now = DateTime.now();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final TextEditingController _controller = TextEditingController();
  String? _message;
  int lastItemPosition = 1;
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
                 Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PublicCodes()));
              },
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            return _alert();
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: stream
                      .where('date', isEqualTo: currentDate)
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No messages yet for today'),
                        );
                      } else {
                        lastItemPosition = snapshot.data!.docs.length;
                        print('position ------------$lastItemPosition first');
                        return messageWall(snapshot.data!.docs);
                      }
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

  messageWall(List<QueryDocumentSnapshot> messages) {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
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
            showAvatar: shouldShowAvatar(index, messages),
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
                // print('==>   $text');
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
    if (_message == null || _message!.isEmpty) {
    } else {
      print('position ------------$lastItemPosition');
      _addMessage(_message!);
      _message = '';
      _controller.clear();
      // itemScrollController.jumpTo(index: lastItemPosition);
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

  bool shouldShowAvatar(int indx, List<QueryDocumentSnapshot> messages) {
    if (indx == 0) return true;
    final previousID = messages[indx - 1].data()['author_id'];
    final authorID = messages[indx].data()['author_id'];
    return authorID != previousID;
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
