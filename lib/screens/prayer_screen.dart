// lib/screens/prayer_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';
import '../services/workmanager_service.dart';
import '../data/bible_data.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Prayer reminders
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersJson = prefs.getString('reminders');
    
    if (remindersJson != null) {
      _reminders = List<Map<String, dynamic>>.from(jsonDecode(remindersJson));
    } else {
      _reminders = [
        {
          'id': 100,
          'time': '06:00 AM',
          'label': 'Morning Prayer',
          'enabled': true,
          'emoji': '🌅'
        },
        {
          'id': 101,
          'time': '12:00 PM',
          'label': 'Noon Prayer',
          'enabled': true,
          'emoji': '☀️'
        },
        {
          'id': 102,
          'time': '06:00 PM',
          'label': 'Evening Prayer',
          'enabled': false,
          'emoji': '🌆'
        },
        {
          'id': 103,
          'time': '09:00 PM',
          'label': 'Bedtime Prayer',
          'enabled': true,
          'emoji': '🌙'
        },
      ];
    }

    // Ensure all reminders have IDs (migration for existing users)
    bool updated = false;
    for (int i = 0; i < _reminders.length; i++) {
      if (_reminders[i]['id'] == null) {
        _reminders[i]['id'] = DateTime.now().millisecondsSinceEpoch ~/ 1000 + i;
        updated = true;
      }
    }

    setState(() {}); // Update UI once after processing all

    if (updated) {
      await _saveReminders(); // This will also call _syncNotificationTasks
    } else {
      _syncNotificationTasks();
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminders', jsonEncode(_reminders));
    _syncNotificationTasks();
  }

  void _syncNotificationTasks() {
    for (int i = 0; i < _reminders.length; i++) {
      final reminder = _reminders[i];
      final idValue = reminder['id'];
      if (idValue == null) {
        debugPrint('PrayerScreen: Skipping sync for reminder at index $i (null ID)');
        continue;
      }
      final notificationId = idValue as int;
      final uniqueName = 'prayer_$notificationId';

      if (reminder['enabled'] == true) {
        final targetTime = _parseTime(reminder['time']);
        WorkmanagerService.schedulePrayerTask(
          uniqueName: uniqueName,
          id: notificationId,
          title: reminder['label'] ?? 'Prayer Time',
          body: 'It is time for your ${reminder['label']}',
          targetTime: targetTime,
        );
      } else {
        WorkmanagerService.cancelTask(uniqueName);
        NotificationService.cancelNotification(notificationId);
      }
    }
  }

  DateTime _parseTime(String? timeStr) {
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
      debugPrint('PrayerScreen: Error parsing time "$timeStr": $e');
      return now; // fallback
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text('Prayer'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD4A017),
          labelColor: const Color(0xFFD4A017),
          unselectedLabelColor: Colors.white38,
          labelStyle: GoogleFonts.cinzel(fontSize: 13, letterSpacing: 1),
          tabs: const [
            Tab(text: 'PRAYERS'),
            Tab(text: 'REMINDERS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrayersTab(),
          _buildRemindersTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReminderDialog(),
        backgroundColor: const Color(0xFFD4A017),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_alarm_rounded),
        label: Text(
          'Add Reminder',
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildPrayersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrayerDetailScreen(prayer: prayer),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1400), Color(0xFF0F0F20)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFD4A017).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  prayer['emoji'] as String,
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer['title'] as String,
                        style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prayer['time'] as String,
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xFFD4A017),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFD4A017),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRemindersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFD4A017).withValues(alpha: 0.15),
                const Color(0xFF0F0F20),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD4A017).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_active_rounded,
                  color: Color(0xFFD4A017), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Set daily reminders to stay connected with God throughout your day.',
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        ..._reminders.asMap().entries.map((e) {
          final index = e.key;
          final reminder = e.value;
          return GestureDetector(
            onTap: () => _showReminderDialog(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: reminder['enabled'] as bool
                      ? const Color(0xFFD4A017).withValues(alpha: 0.4)
                      : Colors.white10,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    reminder['emoji'] as String,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder['time'] as String,
                          style: GoogleFonts.cinzel(
                            color: reminder['enabled'] as bool
                                ? const Color(0xFFD4A017)
                                : Colors.white38,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          reminder['label'] as String,
                          style: GoogleFonts.cormorantGaramond(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: reminder['enabled'] as bool,
                    onChanged: (val) {
                      setState(() {
                        _reminders[index]['enabled'] = val;
                      });
                      _saveReminders();
                    },
                    activeThumbColor: const Color(0xFFD4A017),
                    activeTrackColor: const Color(0xFFD4A017).withValues(alpha: 0.3),
                    inactiveThumbColor: Colors.white30,
                    inactiveTrackColor: Colors.white10,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 80),
      ],
    );
  }

  void _showReminderDialog([int? index]) {
    final bool isEditing = index != null && index >= 0 && index < _reminders.length;
    final reminder = isEditing ? _reminders[index] : null;

    TimeOfDay selectedTime = isEditing
        ? TimeOfDay.fromDateTime(_parseTime(reminder?['time']))
        : const TimeOfDay(hour: 9, minute: 0);
    final labelController =
        TextEditingController(text: isEditing ? (reminder?['label'] as String? ?? '') : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing
                            ? 'EDIT PRAYER REMINDER'
                            : 'ADD PRAYER REMINDER',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFD4A017),
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isEditing)
                        IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded,
                              color: Colors.redAccent),
                          onPressed: () {
                            // Cancel associated tasks before deleting
                            final reminderId = _reminders[index]['id'] as int;
                            WorkmanagerService.cancelTask('prayer_$reminderId');
                            NotificationService.cancelNotification(reminderId);

                            setState(() {
                              _reminders.removeAt(index);
                            });
                            _saveReminders();
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setModalState(() => selectedTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFD4A017).withValues(alpha: 0.4)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              color: Color(0xFFD4A017)),
                          const SizedBox(width: 12),
                          Text(
                            selectedTime.format(context),
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: labelController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Prayer Label',
                      labelStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: const Color(0xFFD4A017).withValues(alpha: 0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFD4A017)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final formattedTime = DateFormat('hh:mm a').format(
                            DateTime(2020, 1, 1, selectedTime.hour,
                                selectedTime.minute));
                        final label = labelController.text.isEmpty
                            ? 'Prayer Time'
                            : labelController.text;

                        setState(() {
                          if (isEditing) {
                            _reminders[index] = {
                              ..._reminders[index],
                              'time': formattedTime,
                              'label': label,
                            };
                          } else {
                            _reminders.add({
                              'id':
                                  DateTime.now().millisecondsSinceEpoch ~/ 1000,
                              'time': formattedTime,
                              'label': label,
                              'enabled': true,
                              'emoji': '🙏',
                            });
                          }
                        });
                        _saveReminders();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A017),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Update Reminder' : 'Save Reminder',
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PrayerDetailScreen extends StatelessWidget {
  final Map<String, String> prayer;

  const PrayerDetailScreen({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: Text(prayer['title']!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(prayer['emoji']!, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            Text(
              prayer['time']!,
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xFFD4A017),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1400), Color(0xFF0F0F20)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD4A017).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                prayer['prayer']!,
                style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 18,
                  height: 2,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Text('🙏', style: TextStyle(fontSize: 20)),
              label: Text(
                'Amen',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A017),
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
