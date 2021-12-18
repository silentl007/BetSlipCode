import 'package:code_realm/home.dart';
import 'package:code_realm/intro.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedIn;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await logged();
  MobileAds.instance.initialize();
  runApp(
    MyApp(),
  );
}

logged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedIn = prefs.getBool('isLogged');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(), home: logged());
  }

  logged() {
    if (loggedIn == null || false) {
      return IntroPage();
    } else
      return HomeSelect();
  }
}
