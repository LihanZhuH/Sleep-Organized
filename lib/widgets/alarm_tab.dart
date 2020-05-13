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
        color: Colors.teal,
      ),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.37,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            updatePreference();
//            Navigator.push(context, MaterialPageRoute(builder: (context) => SleepingScreen()));
            Navigator.pushAndRemoveUntil(context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SleepingScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                ),
                (Route<dynamic> route) => false
            );
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

    // The data picker
    final _datePicker = Container(
        height: 160,
        width: 200,
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
          SizedBox(height: 50,),
          _startButton,
        ],
      ),
    );
  }
}