import 'package:BetSlipCode/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/auth/googleauth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogged', true);
    if (FirebaseAuth.instance.currentUser != null) {
      print('----------- assigning user ------------------');
      user = FirebaseAuth.instance.currentUser;
      setState(() {
        user;
      });
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
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: user != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text('Continue as'),
                      onPressed: () {
                        goto();
                      },
                    ),
                    Text('${user.displayName}'),
                    Text('${user.email}'),
                  ],
                ),
              )
            : LoginGoogle(),
      ),
    );
  }

  logout() {
    // FirebaseAuth.instance.signOut();
    FirebaseAuth.instance.currentUser.delete();
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginGoogle()));
  }
}

class LoginGoogle extends StatefulWidget {
  @override
  _LoginGoogleState createState() => _LoginGoogleState();
}

class _LoginGoogleState extends State<LoginGoogle> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Center(
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

  signin() async {
    try {
      await Authenticate().signInWithGoogle();
      return Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeSelect()));
    } catch (error) {
      print('---------- error initialize----------------');
      print(error);
      print('---------- error here----------------');
    }
  }
}
