import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sleep_organized/models/database.dart';
import 'package:sleep_organized/models/sleep.dart';
import 'package:sleep_organized/screens/sleeping_screen.dart';
import 'package:sleep_organized/widgets/alarm_tab.dart';
import 'package:sleep_organized/widgets/profile_tab.dart';
import 'package:sleep_organized/widgets/stats_tab.dart';

import '../utils.dart';

/*
  The entire home screen consisting of three tabs.
 */
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    // Initializes notification
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // TODO: delete
    setUpFakeDatabase();
  }

  void setUpFakeDatabase() async {
    var database = MyDatabase.instance;
    var db = await database.database;
    database.insertSleep(Sleep(id: 0, start: 1589172747000, end: 1589205147000));
    database.insertSleep(Sleep(id: 1, start: 1588920747000, end: 1588950747000));
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('Notification payload: ' + payload);
    }
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => SleepingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [AlarmTab(), StatsTab(), ProfileTab()];
    final List<String> titles = ["Alarm", "Statistics", "Profile"];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex],
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        brightness: Brightness.dark,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: SizedBox.shrink(),
            icon: Icon(Icons.alarm, size: 33.0,)
          ),
          BottomNavigationBarItem(
            title: SizedBox.shrink(),
            icon: Icon(Icons.equalizer, size: 33.0,)
          ),
          BottomNavigationBarItem(
            title: SizedBox.shrink(),
            icon: Icon(Icons.person, size: 33.0,)
          )
        ],
      ),
      body: tabs[_selectedIndex],
    );
  }
}
