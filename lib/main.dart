import 'package:BetSlipCode/adsense.dart';
import 'package:BetSlipCode/home.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:BetSlipCode/auth/googleauth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adstate = AdSense(initFuture);
  runApp(Provider.value(
    value: adstate,
    builder: (context, child) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      home: HomeSelect(),
    );
  }
}
