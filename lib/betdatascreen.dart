import 'dart:convert';
import 'dart:developer';
import 'package:code_realm/adsense.dart';
import 'package:code_realm/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BetDataScreen extends StatefulWidget {
  final String company;
  BetDataScreen(this.company);
  @override
  _BetDataScreenState createState() => _BetDataScreenState();
}

class _BetDataScreenState extends State<BetDataScreen> {
  InterstitialAd? interAd;
  var get;
  @override
  void initState() {
    super.initState();
    get = _getCodes();
    interLoad();
    colorTheme();
  }

  Color? colorCode = Colors.white;

  colorTheme() {
    if (widget.company == 'Bet9ja') {
      setState(() {
        colorCode = Colors.green;
      });
    } else if (widget.company == 'OnexBet') {
      setState(() {
        colorCode = Colors.blue;
      });
    } else if (widget.company == 'SportyBet') {
      setState(() {
        colorCode = Colors.red;
      });
    } else if (widget.company == 'NairaBet') {
      setState(() {
        colorCode = Colors.blue[800];
      });
    } else if (widget.company == 'MerryBet') {
      setState(() {
        colorCode = Colors.orange;
      });
    } else {
      setState(() {
        colorCode = Colors.white;
      });
    }
  }

  _getCodes() async {
    await dotenv.load(fileName: 'file.env');
    Uri link = Uri.parse('${dotenv.env['api_prefix']}/get/code');
    try {
      var getCodes = await http.get(link);
      if (getCodes.statusCode == 200) {
        var decode = jsonDecode(getCodes.body);
        if (decode.isEmpty) {
          return decode;
        } else {
          return decode[0][widget.company];
        }
      }
    } catch (error) {
      return null;
    }
  }

  void interLoad() {
    InterstitialAd.load(
        request: AdRequest(),
        adUnitId: AdSense.interstitialAdUnitID,
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          interAd = ad;
           interAd!.show();
        }, onAdFailedToLoad: (error) {
          interAd = null;
        }));
  }

  @override
  void dispose() {
    interAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: get,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                UserWidgets().loading(),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          return snapshot.data.length > 0
              ? Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background.png'),
                          fit: BoxFit.cover)),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _toastCopyClipBoard(snapshot.data[index]['slipcode']);
                        },
                        child: Column(
                          children: [
                            Container(
                              color: Color.fromRGBO(44, 44, 44, 1),
                              height: Sizes.h90,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Sizes.h20,
                                        left: Sizes.w40,
                                        right: Sizes.w40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data[index]['slipcode']}',
                                              style: TextStyle(
                                                  fontSize: Sizes.w22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${snapshot.data[index]['sport']}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: Sizes.w10,
                                                  color: colorCode,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              'EARLIEST GAME TIME:  ${snapshot.data[index]['start']}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: Sizes.w10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Divider(
                                              height: Sizes.h2,
                                            ),
                                            Text(
                                              'EARLIEST GAME DATE:  ${snapshot.data[index]['startdate']}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: Sizes.w10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${snapshot.data[index]['odds']}',
                                              style: TextStyle(
                                                  fontSize: Sizes.w18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'ODDS',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: Sizes.w10,
                                                  color: colorCode,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Color.fromRGBO(78, 78, 78, 1),
                              height: 1,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background.png'),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sorry, no bet codes uploaded yet!'),
                      Text('Please try again or check other platforms')
                    ],
                  ),
                );
        } else {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: Center(
              child: ElevatedButton(
                child: Text('Retry'),
                onPressed: () {
                  setState(() {
                    get = _getCodes();
                  });
                },
              ),
            ),
          );
        }
      },
    );
  }

  _toastCopyClipBoard(String odds) {
    Clipboard.setData(new ClipboardData(text: odds));
    return Fluttertoast.showToast(
        msg: "Bet code copied",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: Sizes.w16);
  }
}
