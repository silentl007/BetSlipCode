import 'package:flutter/material.dart';

class BetScreen extends StatefulWidget {
  List<String> selectedBetCompany;
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
      child: Scaffold(),
    );
  }
}
