import 'package:BetSlipCode/betscreen.dart';
import 'package:BetSlipCode/selector.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:BetSlipCode/adsense.dart';

class HomeSelect extends StatefulWidget {
  @override
  _HomeSelectState createState() => _HomeSelectState();
}

class _HomeSelectState extends State<HomeSelect> {
  BannerAd banner;
  List<Check> betCompany = [
    Check('Bet9ja'),
    Check('SportyBet'),
    Check('NairaBet'),
    Check('OnexBet'),
  ];
  List<String> selected = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adstate = Provider.of<AdSense>(context);
    adstate.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            adUnitId: adstate.bannerAdUnitID,
            size: AdSize.banner,
            request: AdRequest(keywords: ['bet','gamble']),
            listener: adstate.adListener)
          ..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Choice(betCompany)),
              RaisedButton(
                child: Text('Continue'),
                onPressed: () => proceed(),
              ),
              banner == null
        ? SizedBox(
            height: 50,
          )
        : Container(
            height: 50,
            child: AdWidget(
              ad: banner,
            ),
          )
            ],
          ),
      ),
    );
  }

  proceed() {
    betCompany.forEach((item) {
      if (item.isSelected) {
        selected.add(item.company);
      }
    });
    if (selected.isNotEmpty) {
      print(selected.toSet().toList());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BetScreen(selected.toSet().toList())));
    } else {
      // snackbar
    }
  }
}
