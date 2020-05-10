import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_organized/screens/home_screen.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Organized',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 4, 66, 131),
          primaryColor: Color.fromARGB(255, 155, 195, 241),
          accentColor: Color.fromARGB(255, 96, 164, 200),
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