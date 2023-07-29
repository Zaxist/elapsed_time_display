library elapsed_time_display;

import 'package:flutter/material.dart';
import 'dart:async';

class TimerText extends StatefulWidget {
  TimerText({
    super.key,
    required this.startTime,
    this.timerTextStyle,
    this.immediateRebuildOnUpdate = false,
    this.interval = const Duration(seconds: 1),
    this.formatter,
  });

  final DateTime startTime;
  final TextStyle? timerTextStyle;

  /// Controls whether the next rebuild will happen instantly when `startTime` changes. If not set to `true` then the Timer will not rebuild until the next scheduled tick (every 1 second by default), even when `startTime` has changed.
  final bool immediateRebuildOnUpdate;
  final Duration interval;
  final String Function(ElapsedTime elapsedTime)? formatter;
  TimerTextState createState() => new TimerTextState();
}

class TimerTextState extends State<TimerText> {
  late Timer timer;
  int elapsedMilliseconds = 0;

  TimerTextState();

  @override
  void initState() {
    timer = new Timer.periodic(widget.interval, callback);
    callback(timer);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimerText oldWidget) {
    // Trigger rebuild immediately when startTime changes
    if (widget.immediateRebuildOnUpdate &&
        oldWidget.startTime != widget.startTime) {
      callback(timer);
    }

    super.didUpdateWidget(oldWidget);
  }

  void callback(Timer timer) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(widget.startTime);
    setState(() {
      elapsedMilliseconds = difference.inMilliseconds;
    });
  }

  String get formatted {
    int seconds = (elapsedMilliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();
    final formatter = widget.formatter;

    // Use user passed formatter if it exists
    if (formatter != null) {
      return formatter(
        ElapsedTime(
          hours: hours,
          minutes: minutes % 60,
          seconds: seconds % 60,
          milliseconds: elapsedMilliseconds % 1000,
        ),
      );
    }

    // Use default formatter
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return new Text(formatted, style: widget.timerTextStyle);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class ElapsedTime {
  ElapsedTime({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.milliseconds,
  });
  int hours;
  int minutes;
  int seconds;
  int milliseconds;
}
