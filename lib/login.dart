import 'package:BetSlipCode/home.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/auth/googleauth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Login'),
            onPressed: () {
              signin();
            },
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
