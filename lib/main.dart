import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/reminder_startup_service.dart';

void main() async {
  print('App is starting...');
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('main: Flutter binding initialized.');

    await NotificationService.initialize();
    debugPrint('main: NotificationService initialized.');

    await NotificationService.requestPermissions();
    debugPrint('main: Permissions requested.');

    // Check if exact alarms can be scheduled
    final canScheduleExact = await NotificationService.canScheduleExactAlarms();
    if (!canScheduleExact) {
      debugPrint(
          'main: WARNING - Exact alarm permission not granted! Alarms may be delayed.');
    } else {
      debugPrint('main: Exact alarm permission granted.');
    }

    // Reschedule all alarms on every startup
    // This fixes the issue where MIUI/OEMs cancel AlarmManager entries on app kill
    await ReminderStartupService.rescheduleAllReminders();
    debugPrint('main: Reminders rescheduled on startup.');

    // Auto-request battery optimization exemption
    // This is the key fix for screen-off and app-killed alarm delivery
    // It shows Android's built-in system dialog asking the user to allow
    // this app to ignore battery optimization
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;
      if (!status.isGranted) {
        await Permission.ignoreBatteryOptimizations.request();
        debugPrint('main: Battery optimization exemption requested.');
      } else {
        debugPrint('main: Battery optimization already exempted.');
      }
    } catch (e) {
      debugPrint('main: Could not request battery optimization: $e');
    }

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    runApp(const GlobalDevoApp());
    debugPrint('main: runApp called.');
  } catch (e, stack) {
    debugPrint('FATAL ERROR DURING STARTUP: $e');
    debugPrint('STACK TRACE: $stack');
    // Start the app anyway if possible to avoid perpetual white screen
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
            child: Text('App Initialization Failed: $e\nPlease restart.')),
      ),
    ));
  }
}

class GlobalDevoApp extends StatelessWidget {
  const GlobalDevoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Daily Devotional',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4A017),
          secondary: Color(0xFFF5C842),
          surface: Color(0xFF0D0D1A),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        textTheme: GoogleFonts.cinzelTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.cinzel(
            color: const Color(0xFFD4A017),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
          iconTheme: const IconThemeData(color: Color(0xFFD4A017)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
