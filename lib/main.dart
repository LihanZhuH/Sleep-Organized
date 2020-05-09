import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_organized/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Organized',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(100, 4, 66, 131),
        primaryColor: Color.fromARGB(255, 155, 195, 241),
        accentColor: Color.fromARGB(100, 96, 164, 200),
        cupertinoOverrideTheme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )
          )
        )
      ),
      home: HomeScreen(),
    );
  }
}
