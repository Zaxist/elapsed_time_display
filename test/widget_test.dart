import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elapsed_time_display/elapsed_time_display.dart';

void main() {
  testWidgets(
    'TimerText displays correct time for right now',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ElapsedTimeDisplay(
            startTime: DateTime.now(),
          ),
        ),
      );
      final finder = find.widgetWithText(ElapsedTimeDisplay, '00:00:00');
      expect(finder, findsOneWidget);
    },
  );
  testWidgets('ElapsedTimeDisplay displays correct time in seconds',
      (widgetTester) async {
    final startTime = DateTime.now().subtract(
      Duration(seconds: 15),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => ElapsedTimeDisplay(startTime: startTime),
      ),
    );

    final finder = find.widgetWithText(ElapsedTimeDisplay, '00:00:15');
    expect(finder, findsOneWidget);
  });
  testWidgets('ElapsedTimeDisplay displays correct time in minutes',
      (widgetTester) async {
    final startTime = DateTime.now().subtract(
      Duration(seconds: 15, minutes: 23),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => ElapsedTimeDisplay(startTime: startTime),
      ),
    );

    final finder = find.widgetWithText(ElapsedTimeDisplay, '00:23:15');
    expect(finder, findsOneWidget);
  });
  testWidgets('ElapsedTimeDisplay displays correct time in hours',
      (widgetTester) async {
    final startTime = DateTime.now().subtract(
      Duration(seconds: 15, minutes: 23, hours: 2),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => ElapsedTimeDisplay(startTime: startTime),
      ),
    );

    final finder = find.widgetWithText(ElapsedTimeDisplay, '02:23:15');
    expect(finder, findsOneWidget);
  });

  testWidgets('ElapsedTimeDisplay displays hours over 24 correctly',
      (widgetTester) async {
    final startTime = DateTime.now().subtract(
      Duration(seconds: 15, minutes: 23, hours: 36),
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => ElapsedTimeDisplay(startTime: startTime),
      ),
    );

    final finder = find.widgetWithText(ElapsedTimeDisplay, '36:23:15');
    expect(finder, findsOneWidget);
  });

  testWidgets('ElapsedTimeDisplay updates every second by default',
      (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ElapsedTimeDisplay(
            startTime: DateTime.now(),
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1), () {});
      await widgetTester.pumpAndSettle(const Duration(seconds: 1));
      expect(
          find.widgetWithText(ElapsedTimeDisplay, '00:00:01'), findsOneWidget);

      await Future.delayed(const Duration(seconds: 1), () {});
      await widgetTester.pumpAndSettle(const Duration(seconds: 1));
      expect(
          find.widgetWithText(ElapsedTimeDisplay, '00:00:02'), findsOneWidget);
    });
  });
}
