import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      tz_data.initializeTimeZones();
      final dynamic timeZone = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName =
          timeZone is String ? timeZone : (timeZone as dynamic).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (details) {},
      );

      final androidPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Channel with maximum priority settings for alarm delivery
        final AndroidNotificationChannel channel = AndroidNotificationChannel(
          'prayer_alarm_v5', // Keep stable channel ID
          'Prayer Alarms',
          description: 'Daily prayer reminders using system alarm sound',
          importance: Importance.max,
          playSound: true,
          sound: const UriAndroidNotificationSound(
              'content://settings/system/alarm_alert'),
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
          enableLights: true,
          showBadge: true,
        );
        await androidPlugin.createNotificationChannel(channel);
        debugPrint('NotificationService: Notification channel created');
      }
    } catch (e) {
      throw Exception('Failed to initialize notifications: $e');
    }
  }

  static Future<void> requestPermissions() async {
    debugPrint('NotificationService: Requesting permissions...');
    // For Android 13+ (API 33+)
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? hasNotificationPermission =
          await androidImplementation.requestNotificationsPermission();
      final bool? hasExactAlarmPermission =
          await androidImplementation.requestExactAlarmsPermission();
      debugPrint(
          'NotificationService: Android Permissions - Notifications: $hasNotificationPermission, Exact Alarm: $hasExactAlarmPermission');
    }

    final iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final bool? granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('NotificationService: iOS Permissions - Granted: $granted');
    }
  }

  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'prayer_alarm_v5',
      'Prayer Alarms',
      channelDescription: 'Daily prayer reminders using system alarm sound',
      importance: Importance.max,
      priority: Priority.max,
      visibility: NotificationVisibility.public,
      icon: '@mipmap/launcher_icon',
      fullScreenIntent: false,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      playSound: true,
      sound: const UriAndroidNotificationSound(
          'content://settings/system/alarm_alert'),
      additionalFlags: Int32List.fromList([
        4, // FLAG_INSISTENT - keeps ringing until dismissed
        268435456, // FLAG_SHOW_WHEN_LOCKED
        2097152, // FLAG_TURN_SCREEN_ON
      ]),
      enableLights: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      ticker: title, // Shows briefly in status bar
      autoCancel: false, // Don't auto-dismiss
      ongoing: false,
      onlyAlertOnce: false, // Always alert
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      ),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformDetails,
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'prayer_alarm_v5',
      'Prayer Alarms',
      channelDescription: 'Daily prayer reminders using system alarm sound',
      importance: Importance.max,
      priority: Priority.max,
      visibility: NotificationVisibility.public,
      icon: '@mipmap/launcher_icon',
      fullScreenIntent: false,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      playSound: true,
      sound: const UriAndroidNotificationSound(
          'content://settings/system/alarm_alert'),
      additionalFlags: Int32List.fromList([
        4, // FLAG_INSISTENT - keeps ringing until dismissed
        268435456, // FLAG_SHOW_WHEN_LOCKED
        2097152, // FLAG_TURN_SCREEN_ON
      ]),
      enableLights: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      ticker: title, // Shows briefly in status bar
      autoCancel: false, // Don't auto-dismiss
      ongoing: false,
      onlyAlertOnce: false, // Always alert
      showWhen: true,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      ),
    );

    // Schedule the notification
    var scheduleTime = tz.TZDateTime.from(scheduledDate, tz.local);
    if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    debugPrint(
        'NotificationService: Scheduling ID $id at $scheduleTime (Local: ${tz.local.name})');

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduleTime,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('NotificationService: Successfully scheduled ID $id');
    } catch (e) {
      debugPrint('NotificationService: Error scheduling ID $id: $e');
    }
  }

  // A helper to test if notifications are working at all
  static Future<void> testNotification() async {
    try {
      // 1. Show immediate notification
      await showImmediateNotification(
        id: 888,
        title: 'Immediate Test 🔔',
        body: 'If you see this, basic notifications are working!',
      );

      // 2. Schedule for 5 seconds later
      final now = tz.TZDateTime.now(tz.local);
      final testTime = now.add(const Duration(seconds: 5));

      await scheduleNotification(
        id: 999,
        title: 'Scheduled Test (5s) ⏰',
        body: 'If you see this, exact alarms are working!',
        scheduledDate: testTime,
      );
    } catch (e) {
      throw Exception('Failed to test notifications: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  // Check if exact alarm permission is granted (Android 12+)
  static Future<bool> canScheduleExactAlarms() async {
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? canSchedule =
          await androidImplementation.canScheduleExactNotifications();
      debugPrint(
          'NotificationService: Can schedule exact alarms: $canSchedule');
      return canSchedule ?? false;
    }
    return false;
  }

  // Get all pending notifications
  static Future<List<dynamic>> getPendingNotifications() async {
    final List<dynamic> notifications =
        await _notificationsPlugin.pendingNotificationRequests();
    debugPrint(
        'NotificationService: ${notifications.length} pending notifications');
    return notifications;
  }
}
