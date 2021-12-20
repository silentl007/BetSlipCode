import 'dart:convert';
import 'package:code_realm/adsense.dart';
import 'package:code_realm/betscreen.dart';
import 'package:code_realm/selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:code_realm/model.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeSelect extends StatefulWidget {
  @override
  _HomeSelectState createState() => _HomeSelectState();
}

class _HomeSelectState extends State<HomeSelect> {
  BannerAd? banner;
  BannerAd? bannerTop;
  bool adTapped = false;
  bool loaded = false;
  Offset? bannerOffset;
  final GlobalKey bannerKey = GlobalKey();
  var getComp;
  List<Check> betCompany = [];
  List<String> selected = [];
  List<String> prefsBetCompanyList = [];
  List<String> prefsSportsList = [];
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
        decode[0]['sports'].forEach((string) => prefsSportsList.add(string));
        prefsBetCompanyList.insert(0, 'Select Platform');
        prefsSportsList.insert(0, 'Select Sports');
        prefs.setStringList('betCompany', prefsBetCompanyList);
        prefs.setStringList('sportCompany', prefsSportsList);
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
        listener: AdListener(
            onAdLoaded: (_) {},
            onAdFailedToLoad: (ad, error) {
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
    banner!.load();
    bannerTop!.load();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: UserWidgets()
            .appbar(appBarName: 'Select Bookies', context: context),
        body: FutureBuilder(
          future: getComp,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover)),
                child: Center(
                  child: UserWidgets().loading(),
                ),
              );
            } else if (snapshot.hasData) {
              return _checker(snapshot.data);
            } else {
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover)),
                child: Center(
                  child: SizedBox(
                    width: Sizes.w200,
                    height: Sizes.h40,
                    child: ElevatedButton(
                      child: Text('Retry'),
                      style: Decorations().buttonDecor(
                          context: context,
                          buttoncolor: Colors.blue,
                          bordercurver: Sizes.w20,
                          bordercolor: Colors.blue),
                      onPressed: () {
                        setState(() {
                          betCompany = [];
                          selected = [];
                          prefsBetCompanyList = [];
                          getComp = getCompanies();
                          bannerLoad();
                        });
                      },
                    ),
                  ),
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _gesture(bannerDisplay(Sizes.h70, bannerTop!)),
            Expanded(child: Choice(betcomp)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Sizes.w20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(
                        255,
                        0,
                        103,
                        255,
                      ),
                      Color.fromARGB(
                        255,
                        68,
                        196,
                        251,
                      ),
                      Color.fromARGB(
                        220,
                        34,
                        122,
                        255,
                      ),
                      Color.fromARGB(
                        255,
                        0,
                        102,
                        255,
                      ),
                    ],
                  )),
              width: Sizes.w200,
              child: ElevatedButton(
                style: Decorations().buttonDecor(
                    context: context,
                    buttoncolor: Colors.transparent,
                    bordercolor: Colors.transparent,
                    bordercurver: 0),
                child: Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.w20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => proceed(),
              ),
            ),
            Divider(
              height: Sizes.h40,
            ),
            _gesture(bannerDisplay(Sizes.h70, banner!))
          ],
        ),
      ),
    );
  }

  textStyling() {
    return TextStyle(
        color: Colors.black, fontSize: Sizes.w20, fontWeight: FontWeight.bold);
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
                backgroundColor: Colors.white,
                content: Text(
                  'Please select one of the plaforms',
                  textAlign: TextAlign.center,
                  style: textStyling(),
                ),
              ));
    } else if (adTapped == false) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                content: Text(
                  'PLEASE SELECT AN AD',
                  textAlign: TextAlign.center,
                  style: textStyling(),
                ),
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
