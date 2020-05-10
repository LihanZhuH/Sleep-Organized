import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_organized/screens/sleeping_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  Alarm tab.
 */
class AlarmTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlarmTabState();
}

class _AlarmTabState extends State<AlarmTab> {
  DateTime _selectedDate;

  /*
    Stores alarm time into shared preference.
   */
  Future<void> updatePreference() async {
    int timestamp = _selectedDate.millisecondsSinceEpoch;
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    if (timestamp < nowTime) {
      timestamp += 24 * 60 * 60 * 1000;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("alarm", timestamp);
    prefs.setInt("sleepTime", nowTime);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final _startButton = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orangeAccent,
            Colors.orange,
            Colors.deepOrange,
          ]
        )
      ),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.37,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            updatePreference();
            // Debug
            Navigator.push(context, MaterialPageRoute(builder: (context) => SleepingScreen()));
//            Navigator.pushAndRemoveUntil(context,
//                MaterialPageRoute(builder: (context) => SleepingScreen()),
//                (Route<dynamic> route) => false);
          });
        },
        child: Text("Start",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )
        ),
      ),
    );

    final _datePicker = Container(
        height: 140,
        width: 200,
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
          use24hFormat: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onDateTimeChanged: (date) {
            _selectedDate = date;
          },
        )
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _datePicker,
          SizedBox(height: 30,),
          _startButton,
        ],
      ),
    );
  }
}