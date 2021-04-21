import 'package:flutter/material.dart';
import 'package:BetSlipCode/model.dart';

class Choice extends StatefulWidget {
  final List<Check> companies;
  Choice(this.companies);
  @override
  _ChoiceState createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
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
