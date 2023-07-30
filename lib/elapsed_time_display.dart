library elapsed_time_display;

import 'package:flutter/material.dart';
import 'dart:async';

class ElapsedTimeDisplay extends StatefulWidget {
  ElapsedTimeDisplay({
    super.key,
    required this.startTime,
    this.style,
    this.immediateRebuildOnUpdate = false,
    this.interval = const Duration(seconds: 1),
    this.formatter,
  });

  /// The point in time from which the timer will count.
  final DateTime startTime;

  /// A TextStyle object to style the timer display.
  final TextStyle? style;

  /// Controls whether the next rebuild will happen instantly when `startTime` changes. If not set to `true` then the Timer will not rebuild until the next scheduled tick (every 1 second by default), even when `startTime` has changed.
  final bool immediateRebuildOnUpdate;

  /// A duration object to set the interval at which the widget will re-evaluate how much time has elapsed, causing a rebuild. This will default to 1 second.
  final Duration interval;

  /// A callback function that can be used to format the Elapsed time. It is passed an instance of the `ElapsedTime` class (which has properties: `hours`, `minutes`, `seconds`, `milliseconds`), and must return a `String`. If nothing is passed, the format will default to: `HH:MM:SS`.
  final String Function(ElapsedTime elapsedTime)? formatter;
  ElapsedTimeDisplayState createState() => new ElapsedTimeDisplayState();
}

class ElapsedTimeDisplayState extends State<ElapsedTimeDisplay> {
  late Timer timer;
  int elapsedMilliseconds = 0;

  ElapsedTimeDisplayState();

  @override
  void initState() {
    timer = new Timer.periodic(widget.interval, callback);
    callback(timer);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ElapsedTimeDisplay oldWidget) {
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
  Text build(BuildContext context) {
    return new Text(formatted, style: widget.style);
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
