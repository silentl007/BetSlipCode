import 'package:BetSlipCode/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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

