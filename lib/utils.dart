import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

// Global notification plugin.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// Alarm sounds
Map<String, String> alarmMap = {
  "Analog watch" : "analog-watch-sound.caf",
  "School bell" : "old-fashioned-school-bell-sound.caf",
  "Alien" : "alien-sound.caf",
};

List<String> alarmNames = ["Analog watch", "School bell", "Alien"];

/*
  Converts from second to hour-minute-second.
 */
String formatHHMMSS(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return "$minutesStr:$secondsStr";
  }

  return "$hoursStr:$minutesStr:$secondsStr";
}

String formatHHMM(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');

  if (hours == 0) {
    return "0:$minutesStr";
  }

  return "$hoursStr:$minutesStr";
}

String formatHHMMPretty(int seconds) {
  int hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  int minutes = (seconds / 60).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');

  if (hours == 0) {
    return "0h ${minutesStr}m";
  }

  return "${hoursStr}h ${minutesStr}m";
}

class TimeUtils {
  static var _dayFormatter = DateFormat("EEEE, MMMM d");
  static var _minuteFormatter = DateFormat("h:mm a, MMM d");

  // Precision set to weekday
  static String dayFormat(DateTime date) => _dayFormatter.format(date);

  // Precision set to minute
  static String minuteFormat(DateTime date) => _minuteFormatter.format(date);

  static int millisecToLocalSec(int milli) {
    return DateTime.fromMillisecondsSinceEpoch(milli).toLocal().hour * 60 * 60
        + DateTime.fromMillisecondsSinceEpoch(milli).toLocal().minute * 60;
  }
}