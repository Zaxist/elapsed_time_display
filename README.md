# Elapsed Time Display Widget

A self updating Elapsed time display widget for flutter.

## Installation

1. include in your `pubspec.yaml` file:

```yml
dependencies:
  elapsed_time_display: ^x.x.x
```

2. Run `flutter pub get`

## Usage

To make the widget available to your code, import the package like so:

```dart
import 'package:elapsed_time_display/elapsed_time_display.dart';
```

It can then be used in your widget tree:

```dart
DateTime startTime = DateTime.now();

@override
Widget build(BuildContext context) {
  return Center(
    child: ElapsedTimeDisplay(
      startTime: startTime,
    ),
  );
}
```

## Props

| Name                     | Required/Optional | Type                                          | Description                                                                                                                                                                                                                                                                           |
| ------------------------ | ----------------- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| startTime                | Required          | `DateTime`                                    | The point in time from which the timer will count.                                                                                                                                                                                                                                    |
| style                    | Optional          | `TextStyle`                                   | A TextStyle object to style the timer display.                                                                                                                                                                                                                                        |
| immediateRebuildOnUpdate | Optional          | `bool`                                        | Controls whether the next rebuild will happen instantly when `startTime` changes. If not set to `true` then the Timer will not rebuild until the next scheduled tick (every 1 second by default), even when `startTime` has changed.                                                  |
| interval                 | Optional          | `Duration`                                    | A duration object to set the interval at which the widget will re-evaluate how much time has elapsed, causing a rebuild. This will default to 1 second.                                                                                                                               |
| formatter                | Optional          | `String Function ( ElapsedTime  elapsedTime)` | A callback function that can be used to format the Elapsed time. It is passed an instance of the `ElapsedTime` class (which has properties: `hours`, `minutes`, `seconds`, `milliseconds`), and must return a `String`. If nothing is passed, the format will default to: `HH:MM:SS`. |
| key                      | Optional          | `Key`                                         | A standard `Key` object.                                                                                                                                                                                                                                                              |

## Example of Formatting

Here is an example of formatting the Elapsed Time string by adding hundredths of a second, and rebuilding the widget more often using the interval prop.

```dart
DateTime startTime = DateTime.now();

@override
Widget build(BuildContext context) {
  return Center(
    child: ElapsedTimeDisplay(
      startTime: DateTime.now(),
      interval: const Duration(milliseconds: 50),
      formatter: (elapsedTime) {
        String hoursStr = elapsedTime.hours.toString().padLeft(2, '0');
        String minutesStr =
            elapsedTime.minutes.toString().padLeft(2, '0');
        String secondsStr =
            elapsedTime.seconds.toString().padLeft(2, '0');
        String hundredthSecondsStr = (elapsedTime.milliseconds / 10)
            .truncate()
            .toString()
            .padLeft(2, '0');

        return '$hoursStr:$minutesStr:$secondsStr:$hundredthSecondsStr';
      },
    ),
  );
}
```
