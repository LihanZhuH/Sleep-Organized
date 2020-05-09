import 'package:flutter/material.dart';
import 'package:sleep_organized/widgets/alarm_tab.dart';
import 'package:sleep_organized/widgets/profile_tab.dart';
import 'package:sleep_organized/widgets/stats_tab.dart';

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
  Widget build(BuildContext context) {
    final List<Widget> tabs = [AlarmTab(), StatsTab(), ProfileTab()];
    final List<String> titles = ["Alarm", "Statistics", "Profile"];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex],
          style: TextStyle(
            color: Theme.of(context).primaryColor
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Brightness.dark,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
