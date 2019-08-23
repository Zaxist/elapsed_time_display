library timer_text;

import 'package:flutter/material.dart';
import 'dart:async';


class TimerText extends StatefulWidget {
  TimerText({this.startTime, this.timerTextStyle});
  final DateTime startTime;
  final TextStyle timerTextStyle;
  TimerTextState createState() => new TimerTextState(startTime: startTime);
}

class TimerTextState extends State<TimerText> {

  Timer timer;
  final DateTime startTime;
  int elapsedSeconds = 0;
  TimerTextState({this.startTime}) {
    timer = new Timer.periodic(new Duration(seconds: 1), callback);
  }
  
  @override
  void initState() {
    callback(timer);
    super.initState();
  }
  void callback(Timer timer) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(startTime);
    setState(() {
      elapsedSeconds = difference.inSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final TextStyle timerTextStyle = const TextStyle(fontSize: 60.0, fontFamily: "Open Sans");
    String formattedTime = TimerTextFormatter.format(elapsedSeconds);
    return new Text(formattedTime, style: widget.timerTextStyle);
  }

  @override
  void dispose() {
    timer.cancel();
    timer = null;
    super.dispose();
  }
}



class TimerTextFormatter {
  static String format(int seconds) {
    //int hundreds = (milliseconds / 10).truncate();
    //int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    //String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    //return "$minutesStr:$secondsStr.$hundredsStr"; 
    return "$hoursStr:$minutesStr:$secondsStr"; 
  }
}