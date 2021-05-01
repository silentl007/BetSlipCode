import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_picker/date_time_picker.dart';

class PublicCodes extends StatefulWidget {
  @override
  _PublicCodesState createState() => _PublicCodesState();
}

class _PublicCodesState extends State<PublicCodes> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ChatBox'),
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
                  stream: stream.orderBy('timestamp').snapshots(),
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
    final String currentDate = DateFormat('yyyy-MM-dd').format(now);
    return ListView.builder(
      itemCount: publicbets.length,
      itemBuilder: (context, index) {
        final data = publicbets[index].data();
        // if (data['date'].toString() == currentDate) {
        return Card(
          child: ListTile(
            title: Text('${data['author']}'),
            subtitle: Column(),
            onTap: () {},
          ),
        );
        // }
        // return Container();
      },
    );
  }

  _addPublicBet() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Post Slip'),
            content: StatefulBuilder(
              builder: (context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: DropdownButton<String>(
                          value: selectbetCompany,
                          items: betCompanies
                              .map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem(
                              child: Text(item),
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
                              child: Text(item),
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
                        //   validator: ,
                        // onSaved: ,
                        ),
                      TextFormField(
                        controller: oddsControl,
                        keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Bet Odd'),
                        //   validator: ,
                        // onSaved: ,
                        ),
                      DateTimePicker(
                        controller: timeControl,
                        type: DateTimePickerType.time,
                        timeLabelText: 'Earliest Game Time',
                        // validator: ,
                        // onSaved: ,
                        onChanged: (value){print(value);},
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  print(betCompanies);
                },
              ),
              // ElevatedButton(
              //   child: Text('Close'),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // )
            ],
          );
        });
  }
}
