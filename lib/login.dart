import 'package:code_realm/home.dart';
import 'package:flutter/material.dart';
import 'package:code_realm/auth/googleauth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    initFire();
  }

  initFire() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Authenticate().initialize();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogged', true);
  }

  String logging = 'login';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Center(
          child: logging == 'login'
              ? ElevatedButton(
                  child: Text('Login'),
                  onPressed: signin,
                )
              : Container(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.blue[200]),
                    backgroundColor: Colors.grey[300],
                    strokeWidth: 2.0,
                  ),
                ),
        ),
      ),
    );
  }

  signin() async {
    try {
      setState(() {
        logging = 'trying';
      });
      await Authenticate().signInWithGoogle();
      return Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeSelect()));
    } catch (error) {
      print('---------- error initialize----------------');
      print(error);
      print('---------- error here----------------');
      setState(() {
        logging = 'login';
      });
    }
  }
}
