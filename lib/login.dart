import 'package:BetSlipCode/chat/chatbox.dart';
import 'package:BetSlipCode/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/auth/googleauth.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  var user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFire();
  }

  initFire() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Authenticate().initialize();
    if (FirebaseAuth.instance.currentUser != null) {
      print('----------- assigning user ------------------');
      user = FirebaseAuth.instance.currentUser;
      setState(() {
        user;
      });
    }
  }

  signin() async {
    try {
      // var userGoogle = await Authenticate().signInWithGoogle();
      // goto();
      print(user);
    } catch (error) {
      print('---------- error initialize----------------');
      print(error);
      print('---------- error here----------------');
    }
  }

  goto() {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeSelect()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Chat Section'),
        //   centerTitle: true,
        // ),
        body: user != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue as:'),
                    Text('${user.displayName}'),
                    Text('${user.email}'),
                    ElevatedButton(
                      child: Text('Continue'),
                      onPressed: () {
                        goto();
                      },
                    )
                  ],
                ),
              )
            : Center(
                child: Container(
                  child: ElevatedButton(
                    child: Text('Login with Google'),
                    onPressed: () {
                      signin();
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
