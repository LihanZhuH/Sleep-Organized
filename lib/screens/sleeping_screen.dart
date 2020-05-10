import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_organized/screens/home_screen.dart';
import 'package:sleep_organized/screens/wakeup_screen.dart';
import 'package:sleep_organized/utils.dart';

/*
  The screen user sees when sleeping.
 */
class SleepingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SleepingScreenState();
}

class _SleepingScreenState extends State<SleepingScreen> {
  int _alarmTimestamp, _timeLeft;
  String _displayText = "00.00";
  StreamSubscription _sub;

  void setUp() async {
    // Setup preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _alarmTimestamp = prefs.getInt("alarm") ?? DateTime.now().millisecondsSinceEpoch;

    // Setup timer
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    int timeLeft = _alarmTimestamp - currentTimestamp;

    scheduleNotification(timeLeft);
    print(timeLeft);
    CountdownTimer countdownTimer =
    CountdownTimer(Duration(milliseconds: timeLeft), Duration(seconds: 1));
    _sub = countdownTimer.listen(null);
    _sub.onData((duration) {
      timeLeft -= 1000;

      this.onTimerTick(timeLeft);
      print('Counting down: $timeLeft');
    });

    _sub.onDone(() {
      print("Done.");
      // TODO: fires alarm and screen transition
      _sub.cancel();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => WakeUpScreen()),
              (Route<dynamic> route) => false);
    });
  }

  void onTimerTick(int newTimestamp) {
    setState(() {
      _timeLeft = newTimestamp;
    });
  }

  void scheduleNotification(int timeLeft) {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(milliseconds: timeLeft));
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('Unique id',
        'channel name', 'channel description');
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.schedule(
        0, "Alarm", "Wake up!",
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  @override
  void initState() {
    super.initState();
    _timeLeft = 0;
    setUp();
  }

  @override
  Widget build(BuildContext context) {
    final _cancelButton = Container(
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
            // TODO: erase entry
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
          });
        },
        child: Text("Cancel",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Time until wake up:",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30
              ),
            ),
            SizedBox(height: 20,),
            Text(formatHHMMSS((_timeLeft/1000).round()),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 35
              ),
            ),
            SizedBox(height: 60,),
            _cancelButton,
          ],
        )
      ),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}