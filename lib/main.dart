import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_organized/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Organized',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 3, 46, 91),
          primaryColor: Color.fromARGB(255, 210, 230, 253),
          accentColor: Color.fromARGB(255, 74, 170, 222),
          bottomAppBarColor: Color.fromARGB(255, 3, 30, 60),
          fontFamily: 'OpenSans',
          cupertinoOverrideTheme: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  )
              )
          )
      ),
      home: HomeScreen(),
    );
  }
}