import 'package:BetSlipCode/login.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      onDone: () => _onIntroEnd(),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      pages: [
        PageViewModel(
          bodyWidget: Center(child: Text('Page1'),)
        ),
        PageViewModel(
          bodyWidget: Center(child: Text('Page2'),)
        ),
        PageViewModel(
          bodyWidget: Center(child: Text('Page3'),)
        ),
      ],
    );
  }

  _onIntroEnd() {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Login()));
  }
}
