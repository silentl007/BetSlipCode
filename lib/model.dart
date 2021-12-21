import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Check {
  String company;
  bool isSelected = false;
  Check(this.company);
}

class UserWidgets {
  appbar(
      {required String appBarName,
      required BuildContext context,
      Widget? actionBar}) {
    Sizes().widthSizeCalc(context);
    Sizes().heightSizeCalc(context);
    return AppBar(
      title: Text(
        appBarName,
        style: TextStyle(fontSize: Sizes.w25, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      toolbarHeight: Sizes.h100,
      actions: appBarName == 'Select Bookies' ? null : [actionBar!],
      flexibleSpace: Image(
        image: AssetImage(appBarName == 'Chatroom'
            ? 'assets/chatroomappbar.png'
            : 'assets/appbar.png'),
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  loading() {
    return Container(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[200]!),
        backgroundColor: Colors.grey[300],
        strokeWidth: 2.0,
      ),
    );
  }
}

class Decorations {
  buttonDecor(
      {Color? buttoncolor,
      Color? bordercolor,
      double? bordercurver,
      @required BuildContext? context}) {
    double size = MediaQuery.of(context!).size.width;
    double w5 = size * .0118;
    return ElevatedButton.styleFrom(
        elevation: 10,
        primary: buttoncolor,
        side: BorderSide(
          color: bordercolor ?? Colors.white,
        ),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(bordercurver ?? w5))));
  }

  formDecor(String hint, BuildContext context) {
    Sizes().widthSizeCalc(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Color.fromRGBO(146, 146, 146, 1)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.w20),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      filled: true,
      fillColor: Color.fromRGBO(55, 55, 55, 1),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: IOSInitializationSettings(
              requestSoundPermission: false,
              requestBadgePermission: false,
              requestAlertPermission: false,
            ),
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "Code Realm",
        "Code Realm",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

class Sizes {
  static double? size;
  // height
  static double h220 = 0;
  static double h40 = 0;
  static double h24 = 0;
  static double h16 = 0;
  static double h18 = 0;
  static double h80 = 0;
  static double h45 = 0;
  static double h8 = 0;
  static double h32 = 0;
  static double h30 = 0;
  static double h200 = 0;
  static double h10 = 0;
  static double h5 = 0;
  static double h20 = 0;
  static double h35 = 0;
  static double h22 = 0;
  static double h120 = 0;
  static double h350 = 0;
  static double h250 = 0;
  static double h100 = 0;
  static double h60 = 0;
  static double h2 = 0;
  static double h38 = 0;
  static double h50 = 0;
  static double h400 = 0;
  static double h150 = 0;
  static double h15 = 0;
  static double h1 = 0;
  static double h500 = 0;
  static double h65 = 0;
  static double h110 = 0;
  static double h130 = 0;
  static double h300 = 0;
  static double h25 = 0;
  static double h13 = 0;
  static double h17 = 0;
  static double h70 = 0;
  static double h12 = 0;
  static double h355 = 0;
  static double h180 = 0;
  static double h3 = 0;
  static double h7 = 0;
  static double h600 = 0;
  static double h44 = 0;
  static double h165 = 0;
  static double h330 = 0;
  static double h90 = 0;
  // Width
  static double w40 = 0;
  static double w180 = 0;
  static double w24 = 0;
  static double w16 = 0;
  static double w18 = 0;
  static double w80 = 0;
  static double w45 = 0;
  static double w8 = 0;
  static double w32 = 0;
  static double w30 = 0;
  static double w200 = 0;
  static double w10 = 0;
  static double w5 = 0;
  static double w20 = 0;
  static double w35 = 0;
  static double w22 = 0;
  static double w120 = 0;
  static double w350 = 0;
  static double w250 = 0;
  static double w100 = 0;
  static double w60 = 0;
  static double w2 = 0;
  static double w38 = 0;
  static double w50 = 0;
  static double w400 = 0;
  static double w150 = 0;
  static double w15 = 0;
  static double w1 = 0;
  static double w500 = 0;
  static double w65 = 0;
  static double w110 = 0;
  static double w130 = 0;
  static double w300 = 0;
  static double w25 = 0;
  static double w13 = 0;
  static double w17 = 0;
  static double w70 = 0;
  static double w7 = 0;
  static double w12 = 0;
  static double w211 = 0;
  static double w4 = 0;
  static double w230 = 0;
  void widthSizeCalc(BuildContext context) {
    // most of the smaller numbers are for font sizes, bigger numbers for height of widgets
    size = MediaQuery.of(context).size.width;
    w4 = size! * .00945;
    w211 = size! * .5;
    w230 = size! * .5437;
    w40 = size! * .0945;
    w16 = size! * .0378;
    w18 = size! * .0425;
    w80 = size! * .1891;
    w45 = size! * .10638;
    w8 = size! * .0189;
    w32 = size! * .0756;
    w30 = size! * .0709;
    w70 = size! * .16548;
    w7 = size! * .016548;
    w200 = size! * .47281;
    w10 = size! * .0236;
    w5 = size! * .0118;
    w20 = size! * .04728;
    w24 = size! * .0567;
    w35 = size! * .0827;
    w180 = size! * .42533;
    w22 = size! * .052;
    w120 = size! * .28368;
    w350 = size! * .82742;
    w250 = size! * .591;
    w100 = size! * .2364;
    w60 = size! * .1418;
    w2 = size! * .0047;
    w38 = size! * .0898;
    w50 = size! * .1182;
    w400 = size! * .9456;
    w150 = size! * .3546;
    w15 = size! * .03546;
    w1 = size! * .002364;
    w500 = size! * 1.1820;
    w65 = size! * .15366;
    w110 = size! * .26;
    w130 = size! * .3073;
    w300 = size! * .7092;
    w25 = size! * .0591;
    w13 = size! * .0307;
    w17 = size! * .04018;
    w70 = size! * .16548;
    w12 = size! * .0283;
  }

  void heightSizeCalc(BuildContext context) {
    size = MediaQuery.of(context).size.height;
    h220 = size! * 0.275;
    h600 = size! * 0.7509;
    h40 = size! * .05;
    h24 = size! * .03;
    h16 = size! * .02;
    h18 = size! * .0225;
    h80 = size! * .1;
    h45 = size! * .05632;
    h8 = size! * .01;
    h32 = size! * .04;
    h30 = size! * .0375;
    h70 = size! * .08761;
    h200 = size! * .25;
    h10 = size! * .0125;
    h5 = size! * .00625;
    h20 = size! * .025;
    h24 = size! * .03;
    h35 = size! * .0438;
    h22 = size! * .02753;
    h120 = size! * .15;
    h350 = size! * .438;
    h250 = size! * .313;
    h100 = size! * .125;
    h60 = size! * .0751;
    h2 = size! * .0025;
    h38 = size! * .0476;
    h50 = size! * .0626;
    h400 = size! * .5;
    h150 = size! * .1877;
    h15 = size! * .0187;
    h1 = size! * .00125156;
    h500 = size! * .626;
    h65 = size! * .0814;
    h110 = size! * .13767;
    h130 = size! * .1627;
    h300 = size! * .375469;
    h25 = size! * .031289;
    h13 = size! * .01627;
    h17 = size! * .0212765;
    h70 = size! * .087609;
    h12 = size! * .015018;
    h355 = size! * .444305;
    h180 = size! * .225;
    h7 = size! * .008761;
    h3 = size! * .00375;
    h44 = size! * .05506;
    h165 = size! * .2065;
    h330 = size! * .4130162;
    h90 = size! * .112640;
  }
}
