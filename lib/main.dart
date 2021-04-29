import 'package:BetSlipCode/adsense.dart';
import 'package:BetSlipCode/intro.dart';
import 'package:BetSlipCode/login.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedIn;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  logged();
  final initFuture = MobileAds.instance.initialize();
  final adstate = AdSense(initFuture);
  runApp(Provider.value(
    value: adstate,
    builder: (context, child) => MyApp(),
  ));
}

void logged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedIn = prefs.getBool('isLogged');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   appBarTheme: AppBarTheme(
      //     color: Colors.red
      //   ),
      //   indicatorColor: Colors.yellow,
      //   brightness: Brightness.dark
      // ),
      theme: ThemeData.dark(),
      home: loggedIn == null || false ? IntroPage() : Login(),
    );
  }
}
