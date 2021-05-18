import 'dart:convert';
import 'package:BetSlipCode/betscreen.dart';
import 'package:BetSlipCode/selector.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:BetSlipCode/adsense.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeSelect extends StatefulWidget {
  @override
  _HomeSelectState createState() => _HomeSelectState();
}

class _HomeSelectState extends State<HomeSelect> {
  BannerAd banner;
  bool loaded = false;
  var getComp;
  List<Check> betCompany = [];
  List<String> selected = [];
  List<String> prefsBetCompanyList = [];

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComp = getCompanies();
    // bannerFunc();
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

  // bannerFunc(){
  //       final adstate = Provider.of<AdSense>(context);
  //   adstate.initialization.then((status) {
  //     setState(() {
  //       banner = BannerAd(
  //           adUnitId: adstate.bannerAdUnitID,
  //           size: AdSize.banner,
  //           request: AdRequest(keywords: ['bet', 'gamble']),
  //           listener: adstate.adListener)
  //         ..load();
  //     });
  //   });
  // }

  // bannerFunc() {
  //   print('here');
  //   banner = BannerAd(
  //       adUnitId: AdSense().bannerAdUnitID,
  //       size: AdSize.banner,
  //       request: AdRequest(keywords: ['bet', 'gamble']),
  //       listener:
  //       AdListener(onAdLoaded: (_) {
  //         setState(() {
  //           loaded = true;
  //         });
  //       }, onAdFailedToLoad: (ad, error) {
  //         print('---------------------------------------');
  //         print('Add error: ${ad.adUnitId}, the error: $error');
  //         print('---------------------------------------');
  //       })

  //       );
  // }

  loadAd() {
    if (loaded) {
      return Container(
        width: banner.size.width.toDouble(),
        child: AdWidget(
          ad: banner,
        ),
      );
    } else {
      return CircularProgressIndicator();
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Please Select'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {},
            )
          ],
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
          // loadAd()
          Container(
            height: sHeight,
            width: double.infinity,
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
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Caution!'),
                content: Text('Please select one of the plaforms'),
              ));
    }
  }
}
