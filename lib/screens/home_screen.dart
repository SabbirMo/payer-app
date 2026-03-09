// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'bible_screen.dart';
import 'prayer_screen.dart';
import 'baby_screen.dart';
import 'songs_screen.dart';
import 'wallpapers_screen.dart';
import 'names_screen.dart';
import 'donation_screen.dart';
import 'water_reminder_screen.dart';
import 'bible_quotes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _floatController;

  final List<Widget> _screens = [
    const _HomeTab(),
    const BibleScreen(),
    const PrayerScreen(),
    const SongsScreen(),
    const BabyScreen(),
  ];

  void showDonationDialog() {
    showDialog(
      context: context,
      builder: (context) => const DonationScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    _floatController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);

    // Check battery optimization after the first frame
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkBatteryOptimization());
  }

  Future<String> _readDeviceManufacturer() async {
    try {
      // Use ProcessResult to call getprop on Android
      if (Platform.isAndroid) {
        final result =
            await Process.run('getprop', ['ro.product.manufacturer']);
        return result.stdout.toString().trim().toUpperCase();
      }
    } catch (_) {}
    return '';
  }

  Map<String, dynamic> _getBrandData() {
    return {
      'XIAOMI': {
        'steps': [
          'Settings → Apps → Manage Apps → ${_appName()}',
          'Tap "Autostart" → Enable ✅',
          'Tap "Battery Saver" → "No restrictions"',
          'Settings → Notifications → ${_appName()} → "Allow notifications on lockscreen" ✅',
        ],
        'extraIntent': 'com.miui.securitycenter/.MainActivity',
      },
      'REDMI': {
        'steps': [
          'Settings → Apps → Manage Apps → ${_appName()}',
          'Tap "Autostart" → Enable ✅',
          'Tap "Battery Saver" → "No restrictions"',
          'Settings → Notifications → ${_appName()} → "Allow notifications on lockscreen" ✅',
        ],
        'extraIntent': 'com.miui.securitycenter/.MainActivity',
      },
      'HUAWEI': {
        'steps': [
          'Phone Manager → Protected Apps → Enable ✅',
          'Battery → App Launch → Manage Manually for ${_appName()}',
        ],
        'extraIntent':
            'com.huawei.systemmanager/.optimize.process.ProtectActivity',
      },
      'HONOR': {
        'steps': [
          'Phone Manager → Protected Apps → Enable for ${_appName()} ✅',
          'Battery → App Launch → Manage Manually',
        ],
        'extraIntent':
            'com.huawei.systemmanager/.optimize.process.ProtectActivity',
      },
      'SAMSUNG': {
        'steps': [
          'Settings → Battery → Background Usage Limits',
          'Find ${_appName()} → Set "Never Sleeping" ✅',
          'Settings → Apps → ${_appName()} → Battery → Unrestricted',
          'Settings → Notifications → Advanced → "Remove notification when app is closed" → DISABLE ✅',
        ],
        'extraIntent': null,
      },
      'OPPO': {
        'steps': [
          'Settings → Battery → Energy Saver',
          '"Allow background activity" for ${_appName()} ✅',
          'Settings → Apps → Auto Start → Enable',
        ],
        'extraIntent': 'com.coloros.oppoguardelf/.powerfragment.PowerFragment',
      },
      'REALME': {
        'steps': [
          'Settings → Battery → Background Power Consumption',
          'Find ${_appName()} → Enable ✅',
          'Settings → Apps → Auto Start → Enable',
        ],
        'extraIntent': 'com.coloros.oppoguardelf/.powerfragment.PowerFragment',
      },
      'VIVO': {
        'steps': [
          'iManager → App Manager → Auto Start',
          'Find ${_appName()} → Enable ✅',
          'Settings → Battery → High Background Power → Allow',
        ],
        'extraIntent': 'com.iqoo.secure/.ui.phoneoptimize.AddWhiteListActivity',
      },
      'ONEPLUS': {
        'steps': [
          'Settings → Battery → Battery Optimization',
          'Find ${_appName()} → "Don\'t Optimize" ✅',
          'Settings → Apps → ${_appName()} → Battery → Unrestricted',
        ],
        'extraIntent': null,
      },
    };
  }

  String _appName() => 'Daily Devotional';

  Future<Map<String, dynamic>> _getBrandInfo() async {
    final manufacturer = await _readDeviceManufacturer();
    final brandData = _getBrandData();

    for (final key in brandData.keys) {
      if (manufacturer.contains(key)) {
        return brandData[key]!;
      }
    }

    // Universal fallback
    return {
      'steps': [
        'Settings → Battery → Battery Optimization',
        'Find ${_appName()} → "Don\'t Optimize" or "Unrestricted" ✅',
        'Settings → Apps → ${_appName()} → Autostart → Enable (if available)',
        'Tap "Open Battery Settings" below',
      ],
      'extraIntent': null,
    };
  }

  Future<void> _checkBatteryOptimization() async {
    final prefs = await SharedPreferences.getInstance();

    // Always check battery optimization status on app start
    try {
      final isExempted = await Permission.ignoreBatteryOptimizations.isGranted;

      // Check if user dismissed the dialog permanently
      final dismissed = prefs.getBool('battery_setup_dismissed') ?? false;

      if (!isExempted && !dismissed && mounted) {
        // Check when we last showed the dialog
        final lastShown = prefs.getInt('last_battery_prompt') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        final hoursSinceLastPrompt = (now - lastShown) / (1000 * 60 * 60);

        // Show dialog if never shown or if 24 hours have passed
        if (lastShown == 0 || hoursSinceLastPrompt >= 24) {
          await prefs.setInt('last_battery_prompt', now);

          // Show brand-specific dialog with auto-request
          if (mounted) {
            _showBatteryOptimizationDialog();
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking battery optimization: $e');
    }
  }

  void _showBatteryOptimizationDialog() async {
    // Get brand-specific info
    final brandInfo = await _getBrandInfo();
    final steps = brandInfo['steps'] as List<String>;
    final manufacturer = await _readDeviceManufacturer();

    // Bengali brand names for better UX
    final brandNameBengali = {
      'XIAOMI': 'Xiaomi/Redmi',
      'REDMI': 'Xiaomi/Redmi',
      'SAMSUNG': 'Samsung',
      'OPPO': 'OPPO',
      'REALME': 'Realme',
      'VIVO': 'Vivo',
      'ONEPLUS': 'OnePlus',
      'HUAWEI': 'Huawei',
      'HONOR': 'Honor',
    };

    String detectedBrand = 'Android';
    for (final key in brandNameBengali.keys) {
      if (manufacturer.contains(key)) {
        detectedBrand = brandNameBengali[key]!;
        break;
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: const Color(0xFFD4A017).withValues(alpha: 0.3),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.notifications_active_rounded,
                color: Color(0xFFD4A017), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Setup Alarm Notifications',
                style: GoogleFonts.cinzel(
                  color: const Color(0xFFD4A017),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Critical warning banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                      const Color(0xFFFF9800).withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFFF6B6B), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '⚠️ CRITICAL FOR ALARMS',
                            style: GoogleFonts.cinzel(
                              color: const Color(0xFFFF6B6B),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Without this setup, prayer alarms will NOT work when app is closed!',
                            style: GoogleFonts.cormorantGaramond(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main explanation
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A017).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android,
                        color: Color(0xFFD4A017), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Detected Phone: $detectedBrand',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xFFD4A017),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'To ensure prayer alarms work reliably (even when screen is off, app is closed, or removed from recent apps), please complete these settings:',
                style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Step 1: Auto Battery Optimization
              _buildSetupStep(
                number: '1',
                title: 'Disable Battery Optimization',
                description: 'Click the "Allow" button below',
                icon: Icons.battery_charging_full,
                color: const Color(0xFF4CAF50),
              ),
              const SizedBox(height: 12),

              // Step 2: Brand-specific settings (only for problematic brands)
              if (manufacturer.contains('XIAOMI') ||
                  manufacturer.contains('REDMI') ||
                  manufacturer.contains('OPPO') ||
                  manufacturer.contains('REALME') ||
                  manufacturer.contains('VIVO') ||
                  manufacturer.contains('HUAWEI') ||
                  manufacturer.contains('HONOR')) ...[
                _buildSetupStep(
                  number: '2',
                  title: 'Additional Settings for $detectedBrand',
                  description: 'Then click "Open Phone Settings" button',
                  icon: Icons.settings,
                  color: const Color(0xFFFF9800),
                ),
                const SizedBox(height: 12),

                // Show brand-specific instructions
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Required Steps:',
                        style: GoogleFonts.cinzel(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...steps.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  color: const Color(0xFFD4A017),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: GoogleFonts.cormorantGaramond(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Success guarantee message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Color(0xFF4CAF50), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '✅ After setup: Alarms will work even when app is closed from recent apps!',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xFF4CAF50),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('battery_setup_dismissed', true);
              Navigator.pop(context);

              // Show warning that alarms might not work
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '⚠️ Warning: Alarms may NOT work reliably without this setup!',
                      style: GoogleFonts.cormorantGaramond(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: const Color(0xFFFF6B6B),
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            },
            child: Text(
              'Skip (Not Recommended)',
              style: GoogleFonts.cinzel(
                color: Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A017),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.battery_charging_full, size: 18),
            label: Text(
              'Allow',
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            onPressed: () async {
              try {
                final result =
                    await Permission.ignoreBatteryOptimizations.request();
                if (result.isGranted) {
                  if (mounted) {
                    // Check if brand-specific settings needed
                    final needsExtraSettings =
                        manufacturer.contains('XIAOMI') ||
                            manufacturer.contains('REDMI') ||
                            manufacturer.contains('OPPO') ||
                            manufacturer.contains('REALME') ||
                            manufacturer.contains('VIVO') ||
                            manufacturer.contains('HUAWEI') ||
                            manufacturer.contains('HONOR');

                    if (needsExtraSettings) {
                      // Show button to open phone settings
                      Navigator.pop(context);
                      _showExtraSettingsDialog(detectedBrand, steps);
                    } else {
                      // All done!
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '✅ Success! Prayer alarms will now work even when app is closed from recent apps',
                            style: GoogleFonts.cormorantGaramond(
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  }
                }
              } catch (e) {
                Navigator.pop(context);
                await openAppSettings();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSetupStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.cinzel(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: color, size: 24),
        ],
      ),
    );
  }

  void _showExtraSettingsDialog(String brandName, List<String> steps) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: const Color(0xFFD4A017).withValues(alpha: 0.3),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.settings, color: Color(0xFFFF9800), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Final Step',
                style: GoogleFonts.cinzel(
                  color: const Color(0xFFFF9800),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'One more setting required for $brandName phones:',
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF9800).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: GoogleFonts.cinzel(
                                color: const Color(0xFFFF9800),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: GoogleFonts.cormorantGaramond(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '⚠️ WARNING: Complete settings later or alarms won\'t work when app is closed!',
                    style: GoogleFonts.cormorantGaramond(
                        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color(0xFFFF6B6B),
                  duration: const Duration(seconds: 5),
                ),
              );
            },
            child: Text(
              'Skip for Now',
              style: GoogleFonts.cinzel(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(
              'Open Settings',
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ Perfect! Now complete the settings shown to enable alarms when app is closed',
                      style: GoogleFonts.cormorantGaramond(
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A15),
          border: Border(
              top: BorderSide(
                  color: const Color(0xFFD4A017).withValues(alpha: 0.25),
                  width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFD4A017),
          unselectedItemColor: Colors.white24,
          selectedLabelStyle:
              GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.cinzel(fontSize: 9),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded), label: 'Bible'),
            BottomNavigationBarItem(
                icon: Icon(Icons.self_improvement_rounded), label: 'Prayer'),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_note_rounded), label: 'Hymns'),
            BottomNavigationBarItem(
                icon: Icon(Icons.child_care_rounded), label: 'Baby'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _glowCtrl;
  bool _showBanner = false;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    _floatCtrl =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);
    _glowCtrl =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showBanner = true;
          if (!_popupShown) {
            _showDonationPopup();
            _popupShown = true;
          }
        });
      }
    });
  }

  void _showDonationPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: const Color(0xFFD4A017).withValues(alpha: 0.4)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A1F00), Color(0xFF0D0D1A)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4A017).withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💝', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 20),
              Text('Support This Ministry',
                  style: GoogleFonts.cinzel(
                      color: const Color(0xFFD4A017),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
              const SizedBox(height: 14),
              Text(
                  'Your generous support helps us spread the Gospel around the world. Every gift makes a difference.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.5)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DonationScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A017),
                  foregroundColor: Colors.black,
                  elevation: 8,
                  shadowColor: const Color(0xFFD4A017).withValues(alpha: 0.5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('DONATE NOW',
                    style: GoogleFonts.cinzel(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 1)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('MAYBE LATER',
                    style: GoogleFonts.cinzel(
                        color: Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D1A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.5,
                      colors: [Color(0xFF2A1F00), Color(0xFF0D0D1A)]),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _floatCtrl,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                              0, -8 * math.sin(_floatCtrl.value * math.pi)),
                          child: child,
                        ),
                        child: AnimatedBuilder(
                          animation: _glowCtrl,
                          builder: (_, child) => Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFFD4A017).withValues(
                                          alpha: 0.4 + 0.3 * _glowCtrl.value),
                                      blurRadius: 30 + 20 * _glowCtrl.value,
                                      spreadRadius: 5)
                                ]),
                            child: child,
                          ),
                          child: ClipOval(
                              child: Image.asset('assets/images/logo.jpg',
                                  width: 90, height: 90, fit: BoxFit.cover)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('GLOBAL DAILY DEVOTIONAL',
                          style: GoogleFonts.cinzel(
                              color: const Color(0xFFD4A017),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2)),
                      const SizedBox(height: 4),
                      Text(_greeting(),
                          style: GoogleFonts.cormorantGaramond(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _verseCard(),
                const SizedBox(height: 18),
                _alarmSetupReminderCard(),
                const SizedBox(height: 18),
                _sectionLabel('EXPLORE'),
                const SizedBox(height: 10),
                _mainGrid(context),
                if (_showBanner) ...[
                  const SizedBox(height: 22),
                  _sectionLabel('SUPPORT THE MINISTRY'),
                  const SizedBox(height: 10),
                  _donationBanner(context),
                  const SizedBox(height: 18),
                ],
                _challengeCard(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning, Beloved ✨';
    if (h < 17) return 'Good Afternoon, Child of God ✨';
    return 'Good Evening, Blessed One ✨';
  }

  Widget _sectionLabel(String text) => Text(text,
      style: GoogleFonts.cinzel(
          color: const Color(0xFFD4A017),
          fontSize: 11,
          letterSpacing: 3,
          fontWeight: FontWeight.w600));

  Widget _verseCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1A1400), Color(0xFF0F0F20)]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: const Color(0xFFD4A017).withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFD4A017).withValues(alpha: 0.08),
                blurRadius: 20)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFD4A017), size: 14),
            const SizedBox(width: 6),
            Text('VERSE OF THE DAY',
                style: GoogleFonts.cinzel(
                    color: const Color(0xFFD4A017),
                    fontSize: 10,
                    letterSpacing: 2))
          ]),
          const SizedBox(height: 12),
          Text(
              '"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future."',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  height: 1.7)),
          const SizedBox(height: 8),
          Text('— Jeremiah 29:11',
              style: GoogleFonts.cinzel(
                  color: const Color(0xFFD4A017),
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _alarmSetupReminderCard() {
    return FutureBuilder<bool>(
      future: Permission.ignoreBatteryOptimizations.isGranted,
      builder: (context, snapshot) {
        // Only show if battery optimization is NOT granted
        if (snapshot.hasData && !snapshot.data!) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                  const Color(0xFFFF9800).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                  blurRadius: 15,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFFF6B6B), size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '⚠️ ALARM SETUP REQUIRED',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFFF6B6B),
                          fontSize: 12,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Prayer alarms will NOT work reliably without completing battery optimization setup. This is critical for alarms when app is closed.',
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('battery_setup_dismissed');
                      if (mounted) {
                        (context.findAncestorStateOfType<_HomeScreenState>()
                                as _HomeScreenState)
                            ._checkBatteryOptimization();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.settings, size: 18),
                    label: Text(
                      'Setup Now',
                      style: GoogleFonts.cinzel(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        // Don't show anything if battery optimization is already granted
        return const SizedBox.shrink();
      },
    );
  }

  Widget _mainGrid(BuildContext context) {
    final items = [
      {
        'icon': Icons.menu_book_rounded,
        'label': 'Bible Stories',
        'color': const Color(0xFF6B4EFF),
        'screen': const BibleScreen()
      },
      {
        'icon': Icons.self_improvement_rounded,
        'label': 'Prayer',
        'color': const Color(0xFFD4A017),
        'screen': const PrayerScreen()
      },
      {
        'icon': Icons.music_note_rounded,
        'label': 'Hymns & Songs',
        'color': const Color(0xFFFF6B35),
        'screen': const SongsScreen()
      },
      {
        'icon': Icons.child_care_rounded,
        'label': 'Baby Corner',
        'color': const Color(0xFFFF6B9D),
        'screen': const BabyScreen()
      },
      {
        'icon': Icons.abc_rounded,
        'label': 'Baby Names',
        'color': const Color(0xFF4EC9FF),
        'screen': const NamesScreen()
      },
      {
        'icon': Icons.wallpaper_rounded,
        'label': 'Wallpapers',
        'color': const Color(0xFF4CAF50),
        'screen': const WallpapersScreen()
      },
      {
        'icon': Icons.water_drop_rounded,
        'label': 'Water Reminder',
        'color': const Color(0xFF4AC3FF),
        'screen': const WaterReminderScreen()
      },
      {
        'icon': Icons.bakery_dining_rounded,
        'label': 'Daily Bread',
        'color': const Color(0xFFFF9800),
        'url': 'https://odbmedia.org/#'
      },
      {
        'icon': Icons.format_quote_rounded,
        'label': 'Bible Quotes',
        'color': const Color(0xFFE91E63),
        'screen': const BibleQuotesScreen()
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () {
            if (item.containsKey('screen')) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => item['screen'] as Widget));
            } else if (item.containsKey('url')) {
              launchUrl(Uri.parse(item['url'] as String),
                  mode: LaunchMode.inAppBrowserView);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (item['color'] as Color).withValues(alpha: 0.15),
                const Color(0xFF0F0F20)
              ]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: (item['color'] as Color).withValues(alpha: 0.35)),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(item['icon'] as IconData,
                  color: item['color'] as Color, size: 30),
              const SizedBox(height: 8),
              Text(item['label'] as String,
                  style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ]),
          ),
        );
      },
    );
  }

  Widget _donationBanner(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const DonationScreen())),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF1A1400), Color(0xFF0A0A15)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: const Color(0xFFD4A017).withValues(alpha: 0.5)),
          ),
          child: Row(children: [
            const Text('💝', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Support This Ministry',
                      style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('PayPal • Stripe • PayNow\nHelp us reach the world 🌍',
                      style: GoogleFonts.cormorantGaramond(
                          color: Colors.white54,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.5)),
                ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: const Color(0xFFD4A017),
                  borderRadius: BorderRadius.circular(12)),
              child: Text('Give',
                  style: GoogleFonts.cinzel(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
          ]),
        ),
      );

  Widget _challengeCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFF2D7D32).withValues(alpha: 0.2),
            const Color(0xFF0D0D1A)
          ]),
          borderRadius: BorderRadius.circular(18),
          border:
              Border.all(color: const Color(0xFF2D7D32).withValues(alpha: 0.4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('🌱', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text('TODAY\'S CHALLENGE',
                style: GoogleFonts.cinzel(
                    color: const Color(0xFF4CAF50),
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600))
          ]),
          const SizedBox(height: 10),
          Text(
              'Show kindness to someone unexpected today. A smile, a kind word, or a helping hand — let God\'s love flow through you.',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white70, fontSize: 15, height: 1.6)),
          const SizedBox(height: 12),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2D7D32).withValues(alpha: 0.4),
                      foregroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0),
                  child: Text('✓ I Did It!',
                      style: GoogleFonts.cinzel(
                          fontSize: 12, fontWeight: FontWeight.w700)))),
        ]),
      );
}
