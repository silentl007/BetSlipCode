import 'dart:async';
import 'package:code_realm/adsense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_realm/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PublicCodes extends StatefulWidget {
  @override
  _PublicCodesState createState() => _PublicCodesState();
}

class _PublicCodesState extends State<PublicCodes> {
  bool? loaded;
  InterstitialAd? interAd;
  final _keyForm = GlobalKey<FormState>();
  final oddsControl = TextEditingController();
  final betcodeControl = TextEditingController();
  final timeControl = TextEditingController();
  final dateControl = TextEditingController();
  final DateTime now = DateTime.now();
  String selectSports = 'Select Sports';
  String selectbetCompany = 'Select Platform';
  List<String> betCompanies = [];
  List<String> sports = [];
  Color platformColor = Colors.white;
  Color sportsColor = Colors.white;
  var stream = FirebaseFirestore.instance.collection('public_betslip');
  @override
  void initState() {
    super.initState();
    getPrefs();
    interLoad();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    betCompanies = prefs.getStringList('betCompany')!;
    sports = prefs.getStringList('sportCompany')!;
  }

  colorTheme(String company) {
    if (company == 'Bet9ja') {
      return Colors.green;
    } else if (company == 'OnexBet') {
      return Colors.blue;
    } else if (company == 'SportyBet') {
      return Colors.red;
    } else if (company == 'NairaBet') {
      return Colors.blue[800];
    } else if (company == 'MerryBet') {
      return Colors.orange;
    } else {
      return Colors.white;
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
    loaded = true;
  }

  actionButton() {
    return IconButton(
      icon: ImageIcon(
        AssetImage('assets/add.png'),
        color: Colors.white,
      ),
      onPressed: () {
        _addPublicBet();
        if (loaded == true) {
          interAd!.show();
          loaded = false;
        } else {
          interLoad();
          Timer(Duration(seconds: 5), () {
            interAd!.show();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('yyyy-MM-dd').format(now);
    return SafeArea(
      child: Scaffold(
        appBar: UserWidgets().appbar(
            appBarName: 'Public Betcodes',
            context: context,
            actionBar: actionButton()),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: stream
                        .where('date', isEqualTo: currentDate)
                        .orderBy('timestamp')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                                'No bet codes from the public right now',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Sizes.w20)),
                          );
                        }
                        return _listView(snapshot.data!.docs);
                      }
                      return Center(
                        child: UserWidgets().loading(),
                      );
                    }),
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }

  _listView(List<QueryDocumentSnapshot> publicbets) {
    return ListView.builder(
      itemCount: publicbets.length,
      itemBuilder: (context, index) {
        final data = publicbets[index].data();
        // create a dismissable to remove an entry
        return GestureDetector(
          onTap: () {
            _toastCopyClipBoard(data['betcode']);
          },
          child: Column(
            children: [
              Container(
                  height: Sizes.h120,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: Sizes.w10),
                          child: Container(
                            child: CircleAvatar(
                              radius: double.infinity,
                              backgroundImage: NetworkImage(data['photo_url']),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Sizes.h10, right: Sizes.w15, left: Sizes.w20),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['author']}',
                                    style: TextStyle(
                                        fontSize: Sizes.w22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(
                                    height: Sizes.h3,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data['company']}",
                                            style: TextStyle(
                                                fontSize: Sizes.w15,
                                                color: colorTheme(
                                                    "${data['company']}")),
                                          ),
                                          Text(
                                            "${data['betcode']}",
                                            style: TextStyle(
                                                fontSize: Sizes.w22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${data['odds']}",
                                            style: TextStyle(
                                                fontSize: Sizes.w15,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: Sizes.w50),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${data['sports']}",
                                              style: TextStyle(
                                                  fontSize: Sizes.w15,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              "${data['startdate']}",
                                              style: TextStyle(
                                                  fontSize: Sizes.w15,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${data['start']}",
                                              style: TextStyle(
                                                  fontSize: Sizes.w15,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  )),Container(height: Sizes.h1,color: Colors.grey.withOpacity(.3),)
            ],
          ),
        );
      },
    );
  }

  _addPublicBet() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Post Slip',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: Sizes.w25),
            )),
            content: StatefulBuilder(
              builder: (context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      children: [
                        Container(
                          child: DropdownButton<String>(
                            value: selectbetCompany,
                            items: betCompanies
                                .map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item,
                                  style: TextStyle(color: platformColor),
                                ),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (text) {
                              setState(() {
                                selectbetCompany = text!;
                              });
                            },
                          ),
                        ),
                        Divider(
                          height: Sizes.h3,
                          color: Colors.transparent,
                        ),
                        Container(
                          child: DropdownButton<String>(
                            value: selectSports,
                            items: sports.map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item,
                                  style: TextStyle(color: sportsColor),
                                ),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (text) {
                              setState(() {
                                selectSports = text!;
                              });
                            },
                          ),
                        ),
                        Divider(
                          height: Sizes.h3,
                          color: Colors.transparent,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          controller: betcodeControl,
                          decoration:
                              Decorations().formDecor('Bet Code', context),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please fill this entry';
                            }
                          },
                        ),
                        Divider(
                          height: Sizes.h3,
                          color: Colors.transparent,
                        ),
                        TextFormField(
                          controller: oddsControl,
                          keyboardType: TextInputType.number,
                          decoration:
                              Decorations().formDecor('Bet Odd', context),
                          validator: (value) {
                            if (value!.isEmpty) return 'Please fill this entry';
                          },
                        ),
                        Divider(
                          height: Sizes.h3,
                          color: Colors.transparent,
                        ),
                        DateTimePicker(
                          controller: dateControl,
                          type: DateTimePickerType.date,
                          firstDate: DateTime(now.year, now.month, now.day),
                          lastDate: DateTime(2300),
                          decoration: Decorations()
                              .formDecor('Earliest Game Date', context),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please fill this entry';
                            }
                          },
                        ),
                        Divider(
                          height: Sizes.h3,
                          color: Colors.transparent,
                        ),
                        DateTimePicker(
                          controller: timeControl,
                          type: DateTimePickerType.time,
                          decoration: Decorations()
                              .formDecor('Earliest Game Time', context),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please fill this entry';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: Decorations().buttonDecor(
                        context: context,
                        buttoncolor: Colors.blue,
                        bordercurver: Sizes.w20,
                        bordercolor: Colors.blue),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: Sizes.w15),
                    ),
                    onPressed: () {
                      var keyForm = _keyForm.currentState;
                      if (keyForm!.validate()) {
                        if (selectbetCompany == 'Select Platform') {
                          setState(() {
                            platformColor = Colors.red;
                          });
                        } else if (selectSports == 'Select Sports') {
                          setState(() {
                            sportsColor = Colors.red;
                          });
                        } else {
                          _uploadBet();
                          keyForm.reset();
                          _reset();

                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                  VerticalDivider(),
                  ElevatedButton(
                    style: Decorations().buttonDecor(
                        context: context,
                        buttoncolor: Colors.blue,
                        bordercurver: Sizes.w20,
                        bordercolor: Colors.blue),
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: Sizes.w15),
                    ),
                    onPressed: () {
                      _reset();
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          );
        });
  }

  _uploadBet() async {
    final String currentDate = DateFormat('yyyy-MM-dd').format(now);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await stream.add({
        'author': user.displayName ?? 'Anonymous',
        'photo_url': user.photoURL ?? 'https://placeholder.com/150',
        'author_id': user.uid,
        'company': selectbetCompany,
        'betcode': betcodeControl.text,
        'date': currentDate,
        'odds': oddsControl.text,
        'sports': selectSports,
        'start': timeControl.text,
        'startdate': dateControl.text,
        'timestamp': Timestamp.now().toDate(),
      });
    }
  }

  _reset() {
    setState(() {
      selectbetCompany = 'Select Platform';
      selectSports = 'Select Sports';
      sportsColor = Colors.white;
      platformColor = Colors.white;
      oddsControl.clear();
      betcodeControl.clear();
      dateControl.clear();
      timeControl.clear();
    });
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
