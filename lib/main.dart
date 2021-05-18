import 'package:BetSlipCode/home.dart';
import 'package:BetSlipCode/intro.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedIn;
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  logged();
  MobileAds.instance.initialize();
  runApp(
    MyApp(),
  );
}

void logged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedIn = prefs.getBool('isLogged');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: logged());
  }

  logged() {
    print('--------------- $loggedIn ----------------');
    if (loggedIn == null || false) {
      return IntroPage();
    } else
      return HomeSelect();
  }
}
