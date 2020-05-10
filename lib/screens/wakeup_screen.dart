import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_organized/models/database.dart';
import 'package:sleep_organized/models/sleep.dart';
import 'package:sleep_organized/screens/home_screen.dart';
import 'package:sleep_organized/utils.dart';

/*
  The screen after user wakes up.
 */
class WakeUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WakeUpScreen();
}

class _WakeUpScreen extends State<WakeUpScreen> {
  String _sleepDuration;
  String _averageSleep = "";

  void getDataFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int sleepTime = prefs.getInt("sleepTime");
    int alarmTime = prefs.getInt("alarm");
    int duration = alarmTime - sleepTime;
    setState(() {
      _sleepDuration = formatHHMMSS((duration / 1000).round());
    });
    var database = MyDatabase();
    var allSleeps = await database.sleeps();
    int nextId = allSleeps.length;
    int totalDuration = 0;

    await database.insertSleep(Sleep(id: nextId, start: sleepTime, end: alarmTime));

    if (allSleeps.length > 0) {
      for (var sleep in allSleeps) {
        totalDuration += sleep.duration;
        print(sleep.id);
        print("Duration: $totalDuration");
      }
      print(allSleeps.length);
      setState(() {
        _averageSleep = formatHHMMSS((totalDuration / allSleeps.length / 1000).round());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false);
          },
        ),
        title: Text("Sleep Summary"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You slept for $_sleepDuration."),
            SizedBox(height: 20,),
            Text("Your average: " + _averageSleep),
          ],
        ),
      )
    );
  }
}