import 'package:BetSlipCode/betdatascreen.dart';
import 'package:BetSlipCode/home.dart';
import 'package:flutter/material.dart';

class BetScreen extends StatefulWidget {
  final List<String> selectedBetCompany;
  BetScreen(this.selectedBetCompany);
  @override
  _BetScreenState createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.selectedBetCompany.length,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.home),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeSelect()),
                (Route<dynamic> route) => false)),
        appBar: AppBar(
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
    );
  }
}