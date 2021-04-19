import 'package:flutter/material.dart';

class ChatLogin extends StatefulWidget {
  @override
  _ChatLoginState createState() => _ChatLoginState();
}

class _ChatLoginState extends State<ChatLogin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: RaisedButton(
            child: Text('Login with Google'),
            onPressed: (){},
          ),
        ),
      ),
      
    );
  }
}