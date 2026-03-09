// lib/services/reminder_startup_service.dart
// This service reschedules all prayer alarms every time the app starts.
// On MIUI/Xiaomi, when the app is killed, AlarmManager entries are cancelled.
// By rescheduling on startup, we ensure alarms are always registered.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'notification_service.dart';

class ReminderStartupService {
  static Future<void> rescheduleAllReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? remindersJson = prefs.getString('reminders');

      if (remindersJson == null) {
        // No saved reminders, schedule the defaults
        _scheduleDefaults();
        return;
      }

      final reminders =
          List<Map<String, dynamic>>.from(jsonDecode(remindersJson));

      debugPrint(
          'ReminderStartupService: Rescheduling ${reminders.length} reminders...');

      for (final reminder in reminders) {
        if (reminder['enabled'] == true) {
          final idValue = reminder['id'];
          if (idValue == null) continue;

          final notificationId = idValue as int;
          final targetTime = _parseTime(reminder['time'] as String?);

          await NotificationService.scheduleNotification(
            id: notificationId,
            title: reminder['label'] ?? 'Prayer Time',
            body: 'It is time for your ${reminder['label'] ?? 'Prayer'}',
            scheduledDate: targetTime,
          );

          debugPrint(
              'ReminderStartupService: Rescheduled ID $notificationId at ${reminder['time']}');
        }
      }
    } catch (e) {
      debugPrint('ReminderStartupService: Error rescheduling reminders: $e');
    }
  }

  static void _scheduleDefaults() {
    // Schedule default reminders if user hasn't set any
    final defaults = [
      {'id': 100, 'time': '06:00 AM', 'label': 'Morning Prayer'},
      {'id': 101, 'time': '12:00 PM', 'label': 'Noon Prayer'},
      {'id': 103, 'time': '09:00 PM', 'label': 'Bedtime Prayer'},
    ];

    for (final d in defaults) {
      NotificationService.scheduleNotification(
        id: d['id'] as int,
        title: d['label'] as String,
        body: 'It is time for your ${d['label']}',
        scheduledDate: _parseTime(d['time'] as String),
      );
    }
  }

  static DateTime _parseTime(String? timeStr) {
    final now = DateTime.now();
    if (timeStr == null || timeStr.isEmpty) return now;

    try {
      DateTime targetTime;
      if (timeStr.contains('AM') || timeStr.contains('PM')) {
        targetTime = DateFormat('hh:mm a').parse(timeStr);
      } else {
        targetTime = DateFormat('HH:mm').parse(timeStr);
      }
      return DateTime(
          now.year, now.month, now.day, targetTime.hour, targetTime.minute);
    } catch (e) {
      return now;
    }
  }
}
