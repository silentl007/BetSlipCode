import 'dart:convert';

import 'package:BetSlipCode/betscreen.dart';
import 'package:BetSlipCode/selector.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:BetSlipCode/adsense.dart';
import 'package:http/http.dart' as http;

class HomeSelect extends StatefulWidget {
  @override
  _HomeSelectState createState() => _HomeSelectState();
}

class _HomeSelectState extends State<HomeSelect> {
  BannerAd banner;
  var getComp;
  List<Check> betCompany = [];
  List<String> selected = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComp = getCompanies();
  }

  getCompanies() async {
    var link = Uri.parse('https://betslipcode.herokuapp.com/get/company');
    try {
      var getList = await http.get(link);
      if (getList.statusCode == 200) {
        var decode = jsonDecode(getList.body);
        for (var data in decode[0]['company']) {
          betCompany.add(Check(data));
        }
      }
      return betCompany;
    } catch (e) {
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adstate = Provider.of<AdSense>(context);
    adstate.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            adUnitId: adstate.bannerAdUnitID,
            size: AdSize.banner,
            request: AdRequest(keywords: ['bet', 'gamble']),
            listener: adstate.adListener)
          ..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: getComp,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.blue[200]),
                  backgroundColor: Colors.grey[300],
                  strokeWidth: 2.0,
                ),
              ],
            );
          } else if (snapshot.hasData) {
            return _checker(snapshot.data);
          } else {
            return Center(
              child: ElevatedButton(
                child: Text('Retry'),
                onPressed: () {
                  setState(() {
                    getComp = getCompanies();
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }

  _checker(List betcomp) {
    Size size = MediaQuery.of(context).size;
    double sHeight = size.height * 0.06257;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Choice(betcomp)),
          ElevatedButton(
            child: Text('Continue'),
            onPressed: () => proceed(),
          ),
          banner == null
              ? SizedBox(
                  height: sHeight,
                )
              : Container(
                  height: sHeight,
                  child: AdWidget(
                    ad: banner,
                  ),
                )
        ],
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
              builder: (context) =>
                  BetScreen(selectedBetCompany: selected.toSet().toList())));
    } else {
      // snackbar
    }
  }
}
