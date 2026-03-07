// lib/screens/water_reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../services/notification_service.dart';

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({super.key});

  @override
  State<WaterReminderScreen> createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> with TickerProviderStateMixin {
  int _currentIntake = 0;
  int _dailyGoal = 2000;
  bool _remindersEnabled = false;
  int _reminderInterval = 2; // hours
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    // Check if we need to reset for a new day
    final lastDate = prefs.getString('water_last_date');
    if (lastDate != today) {
      await prefs.setString('water_last_date', today);
      await prefs.setInt('water_intake_$today', 0);
    }

    setState(() {
      _currentIntake = prefs.getInt('water_intake_$today') ?? 0;
      _dailyGoal = prefs.getInt('water_goal') ?? 2000;
      _remindersEnabled = prefs.getBool('water_reminders_enabled') ?? false;
      _reminderInterval = prefs.getInt('water_reminder_interval') ?? 2;
    });
  }

  Future<void> _updateIntake(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() => _currentIntake += amount);
    await prefs.setInt('water_intake_$today', _currentIntake);
  }

  Future<void> _resetIntake() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() => _currentIntake = 0);
    await prefs.setInt('water_intake_$today', 0);
  }

  Future<void> _toggleReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('water_reminders_enabled', value);
    setState(() => _remindersEnabled = value);
    _syncReminders();
  }

  void _syncReminders() {
    // Clear old water reminders (IDs 200-210)
    for (int i = 0; i < 10; i++) {
      NotificationService.cancelNotification(200 + i);
    }

    if (_remindersEnabled) {
      // Schedule reminders every _reminderInterval hours, e.g., 8:00, 10:00, etc.
      // We'll schedule for the next 8 intervals starting from 8 AM
      final now = DateTime.now();
      for (int i = 0; i < 8; i++) {
        final hour = 8 + (i * _reminderInterval);
        if (hour > 22) break; // Don't remind after 10 PM

        final scheduleTime = DateTime(now.year, now.month, now.day, hour, 0);
        
        NotificationService.scheduleNotification(
          id: 200 + i,
          title: 'Drink Water 💧',
          body: 'Time to stay hydrated! Have a glass of water.',
          scheduledDate: scheduleTime,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentIntake / _dailyGoal).clamp(0.0, 1.0);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: Text('WATER REMINDER', style: GoogleFonts.cinzel(letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white54),
            onPressed: () {
               showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1A2E),
                  title: Text('Reset Intake?', style: GoogleFonts.cinzel(color: Colors.white)),
                  content: Text('Are you sure you want to reset today\'s water intake?', style: GoogleFonts.cormorantGaramond(color: Colors.white70)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    TextButton(onPressed: () { _resetIntake(); Navigator.pop(context); }, child: const Text('Reset', style: TextStyle(color: Colors.redAccent))),
                  ],
                )
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildLiquidProgress(progress),
            const SizedBox(height: 40),
            Text(
              '$_currentIntake / $_dailyGoal ml',
              style: GoogleFonts.cinzel(
                color: const Color(0xFF4AC3FF),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stay hydrated, stay blessed ✨',
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAddButton(250, 'Glass', Icons.local_drink_rounded),
                _buildAddButton(500, 'Bottle', Icons.wine_bar_rounded),
              ],
            ),
            const SizedBox(height: 50),
            _buildReminderSettings(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLiquidProgress(double progress) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF4AC3FF).withValues(alpha: 0.2), width: 6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4AC3FF).withValues(alpha: 0.1),
            blurRadius: 30,
            spreadRadius: 5,
          )
        ],
      ),
      child: ClipOval(
        child: Stack(
          children: [
            Container(color: const Color(0xFF0F0F20)),
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Positioned(
                  bottom: -220 + (220 * progress),
                  left: -110 + (220 * 0.5 * math.sin(_waveController.value * 2 * math.pi * 0.1)),
                  child: CustomPaint(
                    size: const Size(440, 220),
                    painter: WavePainter(_waveController.value, progress),
                  ),
                );
              },
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: [const Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(2, 2))]
                    ),
                  ),
                  Text(
                    'REACHED',
                    style: GoogleFonts.cinzel(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(int amount, String label, IconData icon) {
    return GestureDetector(
      onTap: () => _updateIntake(amount),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF4AC3FF).withValues(alpha: 0.2), const Color(0xFF0F0F20)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4AC3FF).withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF4AC3FF), size: 30),
            const SizedBox(height: 12),
            Text('+$amount', style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('ML', style: GoogleFonts.cinzel(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.cormorantGaramond(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSettings() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF16162D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active_rounded, color: Color(0xFF4AC3FF), size: 22),
              const SizedBox(width: 12),
              Text('REMINDER SETTINGS', style: GoogleFonts.cinzel(color: Colors.white, fontSize: 12, letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto Reminders', style: GoogleFonts.cinzel(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Get notified to drink water periodically', style: GoogleFonts.cormorantGaramond(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ),
              Switch(
                value: _remindersEnabled,
                onChanged: _toggleReminders,
                activeTrackColor: const Color(0xFF4AC3FF).withValues(alpha: 0.3),
                activeColor: const Color(0xFF4AC3FF),
                inactiveThumbColor: Colors.white24,
                inactiveTrackColor: Colors.white10,
              ),
            ],
          ),
          if (_remindersEnabled) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.white10, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notify me every', style: GoogleFonts.cinzel(color: Colors.white70, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<int>(
                    value: _reminderInterval,
                    dropdownColor: const Color(0xFF1A1A2E),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF4AC3FF)),
                    style: GoogleFonts.cinzel(color: const Color(0xFF4AC3FF), fontWeight: FontWeight.bold),
                    items: [1, 2, 3, 4].map((i) => DropdownMenuItem(
                      value: i,
                      child: Text('$i HOUR${i > 1 ? 'S' : ''}'),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _reminderInterval = val);
                        _syncReminders();
                      }
                    },
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double progress;

  WavePainter(this.animationValue, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4AC3FF), Color(0xFF2196F3)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    
    double waveHeight = 10.0;
    double baseHeight = size.height * (1 - progress);
    
    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);
    
    for (double i = 0; i <= size.width; i++) {
      double y = baseHeight + math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * waveHeight;
      path.lineTo(i, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Draw secondary lighter wave
    final secondPaint = Paint()..color = Colors.white.withValues(alpha: 0.2);
    final secondPath = Path();
    secondPath.moveTo(0, size.height);
    secondPath.lineTo(0, baseHeight + 5);
    for (double i = 0; i <= size.width; i++) {
      double y = baseHeight + 5 + math.cos((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * waveHeight;
      secondPath.lineTo(i, y);
    }
    secondPath.lineTo(size.width, size.height);
    secondPath.close();
    canvas.drawPath(secondPath, secondPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
