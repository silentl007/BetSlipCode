import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBox extends StatefulWidget {
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  TextEditingController _controller = TextEditingController();
  String _message;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ChatBox'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _alert();
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
                child: Container(),
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
      print(_message);
      _message = '';
      _controller.clear();
    }
  }

  _logout() async {
    Navigator.of(context).pop();
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  _alert() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Log out of chat'),
              content: Text('Are you sure you want to log out of chat room?'),
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
