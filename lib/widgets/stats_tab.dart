import 'package:flutter/material.dart';
import 'package:sleep_organized/models/database.dart';
import 'package:sleep_organized/widgets/diagram_painter.dart';
import 'package:sleep_organized/widgets/uniform_box_decoration.dart';
import 'package:sqflite/sqflite.dart';

import '../utils.dart';

/*
  Stats tab.
 */
class StatsTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  List<double> _sleepDurations = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<List<double>> _sleepPeriods = [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0], [0.0, 0.0], [0.0, 0.0], [0.0, 0.0], [0.0, 0.0]];
  Map<int, String> _weekdayMap = {
    1 : "Mon", 2 : "Tue", 3 : "Wed", 4 : "Thur", 5 : "Fri", 6 : "Sat", 7 : "Sun"
  };

  /*
    Generates painted containers
   */
  Widget customBoxContainer(double width, height) => CustomPaint(
    painter: MyBoxPainter(Colors.orange),
    child: Container(
      width: width,
      height: height,
    ),
  );

  Widget customBarContainer(double width, height) => CustomPaint(
    painter: MyBarPainter(Colors.yellow),
    child: Container(
      width: width,
      height: height,
    ),
  );

  /*
    Gets all data from database and updates state
   */
  void queryDatabase() async {
    var database = MyDatabase.instance;
    var db = await database.database;
    var sleepsThisWeek = await database.sleepsThisWeek();
    sleepsThisWeek.forEach((element) {
      if (element.duration / 1000 / 60 / 60 > 12) {
        return;
      }
      setState(() {
        _sleepDurations[DateTime.fromMillisecondsSinceEpoch(element.start).weekday-1] =
            element.duration / 1000 / 60 / 60;
        _sleepPeriods[DateTime.fromMillisecondsSinceEpoch(element.start).weekday-1][0] =
            TimeUtils.millisecToLocalSec(element.start).toDouble() / 60 / 60;
        _sleepPeriods[DateTime.fromMillisecondsSinceEpoch(element.start).weekday-1][1] =
            TimeUtils.millisecToLocalSec(element.end).toDouble() / 60 / 60;
      });
    });
    print(_sleepDurations);
    print(_sleepPeriods);
  }

  @override
  void initState() {
    super.initState();
    queryDatabase();
  }

  @override
  Widget build(BuildContext context) {
    // Diagram for duration.
    final Widget durationWidget = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(15),
      decoration: getUniformBoxDecoration(Theme.of(context).bottomAppBarColor),
      child: Center(
        child: Column(
          children: <Widget>[
            Text("Sleep duration",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontStyle: FontStyle.italic
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 250,
              child: Row(
                children: <Widget>[
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("12h"), Text("10h"), Text("8h"), Text("6h"), Text("4h"), Text("2h"), Text("0h"), Text("", style: TextStyle(fontSize: 1),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8 / 7,
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              _sleepDurations[index] > 0 ? customBoxContainer(15.0, 15.0 + 16 * _sleepDurations[index]) : SizedBox(),
                              Text(_weekdayMap[index+1],
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 14
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Diagram for periods.
    final Widget periodWidget = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(15),
      decoration: getUniformBoxDecoration(Theme.of(context).bottomAppBarColor),
      child: Center(
        child: Column(
          children: <Widget>[
            Text("Sleep period",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontStyle: FontStyle.italic
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 250,
              child: Row(
                children: <Widget>[
                  DefaultTextStyle(
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("12pm"), Text("4pm"), Text("8pm"), Text("12am"), Text("4am"), Text("8am"), Text("12pm"), Text("", style: TextStyle(fontSize: 1),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.8 / 7,
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                _sleepDurations[index] > 0 ? customBarContainer(15.0, 15.0 + 7 * _sleepDurations[index]) : SizedBox(),
                                SizedBox(height: (12 - _sleepPeriods[index][1] % 12) * 10,),
                                Text(_weekdayMap[index+1],
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 14
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            durationWidget,
            SizedBox(height: 10,),
            periodWidget,
          ],
        ),
      ),
    );
  }
}