import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final _keyForm = GlobalKey<FormState>();
  final oddsControl = TextEditingController();
  final betcodeControl = TextEditingController();
  final timeControl = TextEditingController();
  final DateTime now = DateTime.now();
  String selectSports = 'Select Sports';
  String selectbetCompany = 'Select Platform';
  List<String> betCompanies = [];
  List<String> sports = [
    'Select Sports',
    'Mixed',
    'Soccer',
    'Rugby',
    'Basketball',
    'Tennis',
    'Formula 1'
  ];
  Color platformColor = Colors.white;
  Color sportsColor = Colors.white;
  var stream = FirebaseFirestore.instance.collection('public_betslip');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    betCompanies = prefs.getStringList('betCompany');
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('yyyy-MM-dd').format(now);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Public Bet Codes'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addPublicBet();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: stream
                      .where('date', isEqualTo: currentDate)
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isEmpty) {
                        return Center(
                          child: Text('No bet codes from the public right now'),
                        );
                      }
                      return _listView(snapshot.data.docs);
                    }
                    return Center(
                      child: Text('loading'),
                    );
                  }),
            ),
            Container()
          ],
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
        return Card(
          child: ListTile(
            onTap: () {
              _toastCopyClipBoard(data['betcode']);
            },
            title: Text('From: ${data['author']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Platform: ${data['company']}"),
                Text("Code: ${data['betcode']}"),
                Text("Odds: ${data['odds']}"),
                Text("Sports: ${data['sports']}"),
                Text("Earliest game time: ${data['start']}"),
              ],
            ),
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
            title: Center(child: Text('Post Slip')),
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
                                selectbetCompany = text;
                              });
                            },
                          ),
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
                                selectSports = text;
                              });
                            },
                          ),
                        ),
                        TextFormField(
                          controller: betcodeControl,
                          decoration: InputDecoration(labelText: 'Bet Code'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this entry';
                            }
                          },
                        ),
                        TextFormField(
                          controller: oddsControl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Bet Odd'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this entry';
                            }
                          },
                        ),
                        DateTimePicker(
                          controller: timeControl,
                          type: DateTimePickerType.time,
                          timeLabelText: 'Earliest Game Time',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this entry';
                            }
                          },
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  var keyForm = _keyForm.currentState;
                  if (keyForm.validate()) {
                    if (selectbetCompany == 'Select Platform') {
                    } else if (selectSports == 'Select Sports') {
                    } else {
                      _uploadBet();
                      keyForm.reset();
                      _reset();
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              ElevatedButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
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
        'author_id': user.uid,
        'company': selectbetCompany,
        'betcode': betcodeControl.text,
        'date': currentDate,
        'odds': oddsControl.text,
        'sports': selectSports,
        'start': timeControl.text,
        'timestamp': Timestamp.now().toDate(),
      });
    }
  }

  _reset() {
    setState(() {
      selectbetCompany = 'Select Platform';
      selectSports = 'Select Sports';
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
