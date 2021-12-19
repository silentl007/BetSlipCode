import 'package:code_realm/home.dart';
import 'package:code_realm/model.dart';
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
  }

  String logging = 'login';

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backlogin.png'),
                  fit: BoxFit.cover)),
          child: Center(
            child: logging == 'login'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.grey,
                              height: 1,
                              width: Sizes.w100,
                            ),
                            VerticalDivider(color: Colors.transparent),
                            Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.w25,
                                  fontWeight: FontWeight.bold),
                            ),
                            VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Container(
                              color: Colors.grey,
                              height: 1,
                              width: Sizes.w100,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        height: Sizes.h50,
                        width: Sizes.w350,
                        child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                height: Sizes.h30,
                              ),
                              VerticalDivider(),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Sizes.w20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: signin,
                          style: Decorations().buttonDecor(
                              context: context,
                              buttoncolor: Colors.white,
                              bordercurver: Sizes.w50,
                              bordercolor: Colors.white),
                        ),
                      ),
                    ],
                  )
                : Container(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blue[200]!),
                      backgroundColor: Colors.grey[300],
                      strokeWidth: 2.0,
                    ),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLogged', true);
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
