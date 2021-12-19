import 'package:code_realm/model.dart';
import 'package:flutter/material.dart';

class Choice extends StatefulWidget {
  final List<dynamic> companies;
  Choice(this.companies);
  @override
  _ChoiceState createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  @override
  Widget build(BuildContext context) {
    Sizes().heightSizeCalc(context);
    Sizes().widthSizeCalc(context);
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.companies.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.only(left: 70, right: 70),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.companies[index].company, style: textStyling(),),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Colors.blue),
                        value: widget.companies[index].isSelected,
                        onChanged: (s) {
                          widget.companies[index].isSelected =
                              !widget.companies[index].isSelected;
                          setState(() {});
                        }),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  textStyling() {
    return TextStyle(
        color: Colors.white, fontSize: Sizes.w25, fontWeight: FontWeight.bold);
  }
}
