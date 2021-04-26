import 'package:flutter/material.dart';
import 'package:BetSlipCode/auth/googleauth.dart';

class ChatLogin extends StatefulWidget {
  @override
  _ChatLoginState createState() => _ChatLoginState();
}

class _ChatLoginState extends State<ChatLogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Authenticate().initialize();
  }

  googleAuth() async {
    try {
      var userGoogle = await Authenticate().signInWithGoogle();
      print(userGoogle);
    } catch (error) {
      print('---------- error ----------------');
      print(error);
      print('---------- error ----------------');
    }
  }

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
            Expanded(
              child: Container(),
            ),
            Container(
              child: ElevatedButton(
                child: Text('Login with Google'),
                onPressed: () {
                  googleAuth();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
