import 'package:flutter/material.dart';
import 'package:sleep_organized/models/database.dart';
import 'package:sleep_organized/utils.dart';
import 'package:sleep_organized/widgets/uniform_box_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  Profile tab.
 */
class ProfileTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _nightsText = "-", _averageText = "-";
  String _soundName = "";

  void queryDatabase() async {
    var database = MyDatabase.instance;
    var db = await database.database;
    var allSleeps = await database.sleeps();
    var totalDuration = 0.0;
    allSleeps.forEach((element) {
      totalDuration += element.duration;
    });
    double average = totalDuration / allSleeps.length.toDouble();
    print(allSleeps);
    setState(() {
      _nightsText = "${allSleeps.length}";
      _averageText = formatHHMMPretty((average / 1000).round());
    });
  }

  void getPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundName = prefs.getString("sound") ?? "Analog watch";
    });
  }

  void updatePreferredSound(String soundName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sound", soundName);
  }

  @override
  void initState() {
    super.initState();
    queryDatabase();
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    // The widget for user history overview.
    final Widget overviewWidget = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 100.0,
      decoration: getUniformBoxDecoration(Theme.of(context).bottomAppBarColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.brightness_2, color: Theme.of(context).accentColor,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_nightsText,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    Text("Nights",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.access_time, color: Theme.of(context).accentColor,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_averageText,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    Text("Average time",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                    ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );

    // The widget for alarm sound selection.
    final Widget soundSelectorWidget = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 80.0,
      padding: EdgeInsets.all(20),
      decoration: getUniformBoxDecoration(Theme.of(context).bottomAppBarColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Alarm Sound",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(context: context, barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Choose an alarm sound",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    backgroundColor: Colors.teal,
                    content: Container(
                      width: 100,
                      height: 200,
                      child: ListView.builder(
                        itemCount: alarmNames.length,
                        itemBuilder: (context, index) => Card(
                          elevation: 2,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: InkWell(
                            onTap: () {
                              updatePreferredSound(alarmNames[index]);
                              setState(() {
                                _soundName = alarmNames[index];
                              });
                              Navigator.pop(context, true);
                            },
                            child: ListTile(
                              title: Text(alarmNames[index],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18
                                ),
                              ),
                              selected: alarmNames[index] == _soundName,
                            ),
                          ),
                        ),
                      ),
                    ),
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }
              );
            },
            child: Text(_soundName,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            overviewWidget,
            SizedBox(height: 10,),
            soundSelectorWidget,
          ],
        ),
      ),
    );
  }
}