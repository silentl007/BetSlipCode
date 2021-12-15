import 'dart:async';
import 'dart:convert';
import 'package:BetSlipCode/adsense.dart';
import 'package:BetSlipCode/betscreen.dart';
import 'package:BetSlipCode/selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/model.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeSelect extends StatefulWidget {
  @override
  _HomeSelectState createState() => _HomeSelectState();
}

class _HomeSelectState extends State<HomeSelect> {
  BannerAd banner;
  BannerAd bannerTop;
  bool adTapped = false;
  bool loaded = false;
  Offset bannerOffset;
  final GlobalKey bannerKey = GlobalKey();
  var getComp;
  List<Check> betCompany = [];
  List<String> selected = [];
  List<String> prefsBetCompanyList = [];

  @override
  void dispose() {
    banner?.dispose();
    bannerTop?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getComp = getCompanies();
    bannerLoad();
  }

  getCompanies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var link = Uri.parse('https://betslipcode.herokuapp.com/get/company');
    try {
      var getList = await http.get(link);
      if (getList.statusCode == 200) {
        var decode = jsonDecode(getList.body);
        for (var data in decode[0]['company']) {
          prefsBetCompanyList.add(data);
          betCompany.add(Check(data));
        }
        prefsBetCompanyList.insert(0, 'Select Platform');
        prefs.setStringList('betCompany', prefsBetCompanyList);
      }
      return betCompany;
    } catch (e) {
      return null;
    }
  }

  bannerLoad() {
    bannerTop = BannerAd(
        adUnitId: AdSense.bannerAdUnitIDTop,
        size: AdSize.fullBanner,
        request: AdRequest(keywords: ['bet', 'gamble']),
        listener: AdListener(onAdLoaded: (_) {
          // setState(() {
          //   loaded = true;
          // });
        }, onAdFailedToLoad: (ad, error) {
          print('---------------------------------------');
          print('Add error: ${ad.adUnitId}, the error: $error');
          print('---------------------------------------');
        }));
    banner = BannerAd(
        adUnitId: AdSense.bannerAdUnitID,
        size: AdSize.fullBanner,
        request: AdRequest(keywords: ['bet', 'gamble']),
        listener: AdListener(onAdLoaded: (_) {
          setState(() {
            loaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print('---------------------------------------');
          print('Add error: ${ad.adUnitId}, the error: $error');
          print('---------------------------------------');
        }));
    banner.load();
    bannerTop.load();
  }

  bannerDisplay(double height, BannerAd ad) {
    if (loaded) {
      return Container(
        // key: bannerKey,
        height: height,
        width: double.infinity,
        child: AdWidget(
          ad: ad,
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  autoHit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderObj = context.findRenderObject();
      RenderBox bannerBox = bannerKey.currentContext.findRenderObject();
      bannerOffset = bannerBox.localToGlobal(Offset.zero);
      Timer(Duration(seconds: 6), () {
        print('---------- autoHit running -----------------');
        if (renderObj is RenderBox) {
          print('---------- autoHit running within -----------------');
          final hitTestResult = BoxHitTestResult();
          // renderObj.hitTestSelf( bannerOffset);
          if (renderObj.hitTest(hitTestResult, position: bannerOffset)) {
            print('-------------- path: ${hitTestResult.path}');
          } else {
            print('------ else -------- path: ${hitTestResult.path}');
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Please Select'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getComp,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.blue[200]),
                  backgroundColor: Colors.grey[300],
                  strokeWidth: 2.0,
                ),
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
      ),
    );
  }

  _gesture(Widget widget) {
    return GestureDetector(
      child: widget,
      onTap: () => adTapped = true,
          onPanDown: (_) => adTapped = true,
          onPanUpdate: (_) => adTapped = true,
    );
  }

  _checker(List betcomp) {
    Size size = MediaQuery.of(context).size;
    double sHeight = size.height * 0.06257;
    // autoHit();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _gesture(bannerDisplay(sHeight, bannerTop)),
          Expanded(child: Choice(betcomp)),
          ElevatedButton(
            child: Text('Continue'),
            onPressed: () => proceed(),
          ),
          _gesture(bannerDisplay(sHeight, banner))
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
    if (selected.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Caution!'),
                content: Text('Please select one of the plaforms'),
              ));
    } else if (adTapped == false) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Caution!'),
                content: Text('Please tap on one of the ads to support us!'),
              ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BetScreen(selectedBetCompany: selected.toSet().toList())));
    }
  }
}
