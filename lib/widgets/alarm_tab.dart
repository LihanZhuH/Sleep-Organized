import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
  Alarm tab.
 */
class AlarmTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlarmTabState();
}

class _AlarmTabState extends State<AlarmTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 120,
            width: 300,
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 8
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onDateTimeChanged: (value) {

              },
            )
          ),
          RaisedButton(
            child: Text("Start",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }
}