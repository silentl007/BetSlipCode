import 'package:flutter/material.dart';
import 'package:BetSlipCode/model.dart';

class Selector extends StatefulWidget {
  final List<Check> companies;
  Selector(this.companies);
  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.companies.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Row(
            children: <Widget>[
              Checkbox(
                  value: widget.companies[index].isSelected,
                  onChanged: (s) {
                    widget.companies[index].isSelected =
                        !widget.companies[index].isSelected;
                    setState(() {});
                  }),
              Text(widget.companies[index].company),
            ],
          ),
        );
      },
    );
  }
}
