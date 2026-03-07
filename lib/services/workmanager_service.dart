import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Ensure Flutter is initialized in the background isolate
      WidgetsFlutterBinding.ensureInitialized();
      print('Workmanager: Background task started');
      
      // Initialize notification service without requesting permissions
      await NotificationService.initialize();
      
      final int id = inputData?['id'] ?? 0;
      final String title = inputData?['title'] ?? 'Prayer Time';
      final String body = inputData?['body'] ?? 'It is time for prayer';

      print('Workmanager: Showing notification $id with title "$title"');
      await NotificationService.showImmediateNotification(
        id: id,
        title: title,
        body: body,
      );
      print('Workmanager: Notification shown successfully for $id');
      
      return Future.value(true);
    } catch (e) {
      // Log errors to debug console if background task fails
      print('Workmanager Task failed: $e');
      return Future.value(false);
    }
  });
}

class WorkmanagerService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> schedulePrayerTask({
    required String uniqueName,
    required int id,
    required String title,
    required String body,
    required DateTime targetTime,
  }) async {
    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      targetTime.hour,
      targetTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final duration = scheduledDate.difference(now);

    await Workmanager().registerOneOffTask(
      uniqueName,
      'prayerTask',
      initialDelay: duration,
      inputData: {
        'id': id,
        'title': title,
        'body': body,
      },
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<void> schedulePeriodicTask({
    required String uniqueName,
    required String taskName,
    required int id,
    required String title,
    required String body,
    required Duration frequency,
  }) async {
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: frequency,
      initialDelay: frequency,
      inputData: {
        'id': id,
        'title': title,
        'body': body,
      },
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  static Future<void> cancelTask(String uniqueName) async {
    await Workmanager().cancelByUniqueName(uniqueName);
  }
}
