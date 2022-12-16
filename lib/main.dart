import 'package:code_realm/auth/googleauth.dart';
import 'package:code_realm/home.dart';
import 'package:code_realm/intro.dart';
import 'package:code_realm/model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background/flutter_background.dart';

bool? loggedIn;
Future<void> backgroundHandler(RemoteMessage message) async {
  print('------------ coming from here backgroundHandler');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await logged();
  await Authenticate().initialize();
  MobileAds.instance.initialize();
  FirebaseMessaging.instance.subscribeToTopic("coderealm");
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(
    MyApp(),
  );
}

logged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedIn = prefs.getBool('isLogged') ?? false;
}

 class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    notificationFirebase();
    // runbackground();
    LocalNotificationService.initialize(context);
  }

  runbackground() async {
    // this is for persistent notification at the top
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "CodeRealm",
      notificationText: "Running at the back",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'ic_launcher',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    bool hasPermissions = await FlutterBackground.hasPermissions;
    if (hasPermissions) {
      await FlutterBackground.enableBackgroundExecution();
    } else {
      await FlutterBackground.initialize(androidConfig: androidConfig);
      await FlutterBackground.enableBackgroundExecution();
    }
  }

  notificationFirebase() async {
    await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('------------ coming from here getInitialMessage');
      if (message != null) {
        print('working ------------------>');
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('------------ coming from here onMessage');
      }
      LocalNotificationService.display(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('------------ coming from here onMessageOpenedApp');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
      GlobalMaterialLocalizations.delegate
    ], supportedLocales: [
      const Locale('en', 'US'),
    ], theme: ThemeData.dark(), home: log());
  }

  log() {
    if (loggedIn == null || loggedIn == false) {
      return IntroPage();
    } else {
      return HomeSelect();
    }
  }
}
