import 'dart:async';
import 'package:BetSlipCode/adsense.dart';
import 'package:BetSlipCode/betdatascreen.dart';
import 'package:BetSlipCode/chat/chatbox.dart';
import 'package:BetSlipCode/home.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class BetScreen extends StatefulWidget {
  final List<String> selectedBetCompany;
  BetScreen({this.selectedBetCompany});
  @override
  _BetScreenState createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  InterstitialAd interAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interAd = InterstitialAd(
      adUnitId: 'ca-app-pub-7315976017574578/1262603214',
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}'),
        onAdFailedToLoad: (ad, error) =>
            print('Add error: ${ad.adUnitId}, the error: $error'),
      ),
    );
    interAd.load();
    startTimer();
  }

  // @override
  // void dispose() {
  //   interAd?.dispose();
  //   super.dispose();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final adstate = Provider.of<AdSense>(context);
  //   adstate.initialization.then((status) {
  //     setState(() {
  //       interAd = InterstitialAd(
  //           adUnitId: 'ca-app-pub-7315976017574578/1262603214',
  //           request: AdRequest(keywords: ['bet', 'gamble']),
  //           listener: adstate.adListener)
  //         ..load();
  //     });
  //   });
  // }

  void startTimer() {
    Timer(Duration(seconds: 5), () {
      interAd.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeSelect()),
          (Route<dynamic> route) => false),
      child: DefaultTabController(
        length: widget.selectedBetCompany.length,
        initialIndex: 0,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(Icons.home),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeSelect()),
                  (Route<dynamic> route) => false)),
          appBar: AppBar(
            title: Text('Bet Platforms'),
            centerTitle: true,
            actions: [
              Container(
                  child: IconButton(
                icon: Icon(Icons.group),
                onPressed: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatBox()));
                },
              ))
            ],
            elevation: widget.selectedBetCompany.length == 1 ? 0 : 4,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: widget.selectedBetCompany
                  .map((items) => Tab(
                        child: Text(items),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: widget.selectedBetCompany
                .map((items) => BetDataScreen((items)))
                .toList(),
          ),
        ),
      ),
    );
  }
}
