import 'package:code_realm/login.dart';
import 'package:code_realm/model.dart';
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
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return IntroductionScreen(
      globalBackgroundColor: Colors.black,
      key: introKey,
      onDone: () => _onIntroEnd(),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      nextFlex: 0,
      isBottomSafeArea: true,
      isTopSafeArea: true,
      skip: Text('Skip',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Sizes.w20,
            color: Color.fromARGB(
              255,
              68,
              196,
              251,
            ),
          )),
      next: Icon(
        Icons.arrow_forward,
        size: Sizes.w30,
        color: Color.fromARGB(
          255,
          68,
          196,
          251,
        ),
      ),
      done: Text('Done',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Sizes.w20,
            color: Color.fromARGB(
              255,
              68,
              196,
              251,
            ),
          )),
      pages: [
        pageModel(
            slideImage: 'assets/slide1.png',
            text1: 'Welcome to CodeRealm',
            text2:
                'We relieve the overwhelming stress of constantly going through match events to pick that winning combination by providing access to multiple bet codes from different platforms for you to choose from.'),
        pageModel(
            slideImage: 'assets/slide2.png',
            text1: 'Join Our Community',
            text2:
                'Join other CodeRealmers in the chat section and discuss about live sporting events.'),
        pageModel(
            slideImage: 'assets/slide3.png',
            text1: 'Contribute to the Community.',
            text2:
                'Feel good about the chances of your personal slip making that winning run? Share the slip code in the public code section to help out other CodeRealmers')
      ],
    );
  }

  pageModel({
    required String slideImage,
    required String text1,
    required String text2,
  }) {
    return PageViewModel(
        title: '',
        decoration: PageDecoration(
            footerPadding: EdgeInsets.zero,
            boxDecoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover))),
        bodyWidget: Container(
          height: Sizes.h350,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    slideImage,
                  ),
                  fit: BoxFit.contain)),
        ),
        footer: Padding(
          padding: EdgeInsets.only(
              left: Sizes.w30, right: Sizes.w30, top: Sizes.h70),
          child: Column(
            children: [
              Text(text1,
                  style: TextStyle(
                    color: Color.fromARGB(
                      255,
                      68,
                      196,
                      251,
                    ),
                    fontSize: Sizes.w24,
                    fontWeight: FontWeight.w500,
                  )),
              Divider(
                height: Sizes.h20,
                color: Colors.transparent,
              ),
              Text(text2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.3,
                    color: Colors.white,
                    fontSize: Sizes.w20,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ));
  }

  _onIntroEnd() {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Login()));
  }
}
