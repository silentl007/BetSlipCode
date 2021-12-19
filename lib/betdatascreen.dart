import 'dart:convert';
import 'package:code_realm/adsense.dart';
import 'package:flutter/material.dart';
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
  }

  _getCodes() async {
    Uri link = Uri.parse('https://betslipcode.herokuapp.com/get/code');
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
    interAd = InterstitialAd(
      adUnitId: AdSense.interstitialAdUnitID,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          print('---------------------------------------');
          print('Ad loaded: ${ad.adUnitId}');
          interAd!.show();
          print('---------------------------------------');
        },
        onAdFailedToLoad: (ad, error) {
          print('---------------------------------------');
          print('Add error: ${ad.adUnitId}, the error: $error');
          print('---------------------------------------');
        },
      ),
    );
    interAd!.load();
  }

  @override
  void dispose() {
    interAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: get,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[200]!),
                backgroundColor: Colors.grey[300],
                strokeWidth: 2.0,
              ),
            ],
          );
        } else if (snapshot.hasData) {
          return snapshot.data.length > 0
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Icon(
                          Icons.double_arrow,
                          color: Colors.white,
                        ),
                        title: Row(
                          children: [
                            Text('Code: '),
                            Text('${snapshot.data[index]['slipcode']}'),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Text('Odds: '),
                                Text('${snapshot.data[index]['odds']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Sport Type: '),
                                Text('${snapshot.data[index]['sport']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Earliest Game Date: '),
                                Text('${snapshot.data[index]['startdate']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Earliest Game Time: '),
                                Text('${snapshot.data[index]['start']}'),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          _toastCopyClipBoard(snapshot.data[index]['slipcode']);
                        },
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sorry, no bet codes uploaded yet!'),
                    Text('Please try again or check other platforms')
                  ],
                );
        } else {
          return Center(
            child: ElevatedButton(
              child: Text('Retry'),
              onPressed: () {
                setState(() {
                  get = _getCodes();
                });
              },
            ),
          );
        }
      },
    );
  }

  _toastCopyClipBoard(String odds) {
    Clipboard.setData(new ClipboardData(text: odds));
    return Fluttertoast.showToast(
        msg: "Bet code copied to clipboard!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
