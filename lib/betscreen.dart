import 'dart:async';
import 'package:BetSlipCode/adsense.dart';
import 'package:BetSlipCode/betdatascreen.dart';
import 'package:BetSlipCode/chat/chatbox.dart';
import 'package:BetSlipCode/home.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BetScreen extends StatefulWidget {
  final List<String> selectedBetCompany;
  BetScreen({this.selectedBetCompany});
  @override
  _BetScreenState createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeSelect()),
          (Route<dynamic> route) => false),
      child: DefaultTabController(
        length: widget.selectedBetCompany.length,
        initialIndex: 0,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(Icons.home),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeSelect()),
                  (Route<dynamic> route) => false)),
          appBar: AppBar(
            title: Text('Bet Platforms'),
            centerTitle: true,
            actions: [
              Container(
                  child: IconButton(
                icon: Icon(Icons.group),
                onPressed: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatBox()));
                },
              ))
            ],
            elevation: widget.selectedBetCompany.length == 1 ? 0 : 4,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: widget.selectedBetCompany
                  .map((items) => Tab(
                        child: Text(items),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children: widget.selectedBetCompany
                .map((items) => BetDataScreen((items)))
                .toList(),
          ),
        ),
      ),
    );
  }
}
