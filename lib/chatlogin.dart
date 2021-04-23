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
        appBar: AppBar(
          title: Text('Chat Section'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container(),),
            Container(
              child: ElevatedButton(
                child: Text('Login with Google'),
                onPressed: (){},
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}