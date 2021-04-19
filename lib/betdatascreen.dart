import 'dart:convert';
import 'package:flutter/material.dart';
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
  var get;
  @override
  void initState() {
    super.initState();
    get = _getCodes();
  }

  _getCodes() async {
    String link = 'https://betslipcode.herokuapp.com/get/code';
    try {
      var getCodes = await http.get(link);
      if (getCodes.statusCode == 200) {
        var decode = jsonDecode(getCodes.body);
        if (decode.isEmpty) {
          return decode;
        } else {
          if (widget.company == 'Bet9ja') {
            return decode[0]['Bet9ja'];
          } else if (widget.company == 'SportyBet') {
            return decode[0]['SportyBet'];
          } else if (widget.company == 'NairaBet') {
            return decode[0]['NairaBet'];
          } else if (widget.company == 'OnexBet') {
            return decode[0]['OnexBet'];
          }
        }
      }
    } catch (error) {
      print(error);
      return null;
    }
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
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[200]),
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
                                Text('Type: '),
                                Text('${snapshot.data[index]['type']}'),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: "Copied to clipboard!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);

                          Clipboard.setData(new ClipboardData(
                              text: "${snapshot.data[index]['odds']}"));
                        },
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No bet codes uploaded yet!'),
                    Text('Please try again or check other platforms')
                  ],
                );
        } else {
          return Center(
            child: RaisedButton(
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
}
