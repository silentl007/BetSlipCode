import 'package:BetSlipCode/betscreen.dart';
import 'package:BetSlipCode/selector.dart';
import 'package:flutter/material.dart';
import 'package:BetSlipCode/model.dart';

class HomeSelect extends StatefulWidget {
  @override
  _HomeSelectState createState() => _HomeSelectState();
}

class _HomeSelectState extends State<HomeSelect> {
  List<Check> betCompany = [
    Check('Bet9ja'),
    Check('SportyBet'),
    Check('NairaBet'),
    Check('OnexBet'),
  ];
  List<String> selected = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Selector(betCompany)),
            RaisedButton(
              child: Text('Continue'),
              onPressed: () => proceed(),
            ),
          ],
        ),
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
              builder: (context) => BetScreen(selected.toSet().toList())));
    } else {
      // snackbar
    }
  }
}
