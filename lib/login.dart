import 'package:BetSlipCode/chat/chatbox.dart';
import 'package:BetSlipCode/home.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/auth/googleauth.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initFire();
  }

  initFire() async {
    if (Firebase.app().name.isNotEmpty) {
    } else {
      await Authenticate().initialize();
    }
  }

  signin() async {
    try {
      // print(Firebase.app());
      if (Firebase.app().name.isNotEmpty) {
        var userGoogle = await Authenticate().signInWithGoogle();
        goto();
      }
    } catch (error) {
      print('---------- error initialize----------------');
      await Authenticate().initialize();
      var userGoogle = await Authenticate().signInWithGoogle();
      goto();
      print('---------- error here----------------');
    }
  }

  goto() {
    return Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => HomeSelect()));
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
                  signin();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
