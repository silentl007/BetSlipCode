import 'package:code_realm/betdatascreen.dart';
import 'package:code_realm/chat/chatbox.dart';
import 'package:code_realm/home.dart';
import 'package:code_realm/model.dart';
import 'package:flutter/material.dart';

class BetScreen extends StatefulWidget {
  final List<String>? selectedBetCompany;
  BetScreen({this.selectedBetCompany});
  @override
  _BetScreenState createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  @override
  void initState() {
    super.initState();
    colorTheme(widget.selectedBetCompany![0]);
  }

  Color? colorCode = Colors.white;
  Color? colorContainer = Colors.white;

  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeSelect()),
            (Route<dynamic> route) => false);
        return true;
      },
      child: DefaultTabController(
        length: widget.selectedBetCompany!.length,
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
            title: Text('Bookies',
                style: TextStyle(
                    fontSize: Sizes.w25, fontWeight: FontWeight.bold)),
            centerTitle: true,
            toolbarHeight: Sizes.h100,
            actions: [action()],
            flexibleSpace: Image(
              image: AssetImage('assets/appbar.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            elevation: widget.selectedBetCompany!.length == 1 ? 0 : 4,
            bottom: TabBar(
              labelPadding: EdgeInsets.all(0),
              indicatorWeight: Sizes.h7,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: colorContainer,
              physics: NeverScrollableScrollPhysics(),
              onTap: (int) {
                colorTheme(widget.selectedBetCompany![int]);
              },
              tabs: widget.selectedBetCompany!
                  .map((items) => Tab(
                        iconMargin: EdgeInsets.zero,
                        child: Container(
                          height: Sizes.h70,
                          width: double.infinity,
                          color: colorCode,
                          child: Center(
                            child: Text(
                              items,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: widget.selectedBetCompany!
                .map((items) => BetDataScreen((items)))
                .toList(),
          ),
        ),
      ),
    );
  }

  action() {
    return Container(
        child: IconButton(
      icon: ImageIcon(
        AssetImage('assets/chatroom.png'),
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatBox()));
      },
    ));
  }

  colorTheme(String company) {
    if (company == 'Bet9ja') {
      setState(() {
        colorCode = Colors.green;
        colorContainer = Colors.green[400];
      });
    } else if (company == 'OnexBet') {
      setState(() {
        colorCode = Colors.blue;
        colorContainer = Colors.blue[400];
      });
    } else if (company == 'SportyBet') {
      setState(() {
        colorCode = Colors.red;
        colorContainer = Colors.red[400];
      });
    } else if (company == 'NairaBet') {
      setState(() {
        colorCode = Colors.blue[800];
        colorContainer = Colors.blue[400];
      });
    } else if (company == 'MerryBet') {
      setState(() {
        colorCode = Colors.orange;
        colorContainer = Colors.orange[400];
      });
    } else {
      setState(() {
        colorCode = Colors.white;
        colorContainer = Colors.white;
      });
    }
  }
}
