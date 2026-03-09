# Alarm Notification Fix - Background App Clear Issue

## সমস্যা (Problem)
যখন app background থেকে clear করা হয় (recent apps থেকে swipe করে), তখন alarm notifications কাজ করছিল না।

## সমাধান (Solution)
নিচের পরিবর্তনগুলি করা হয়েছে:

### 1. AndroidManifest.xml Updates

#### যোগ করা হয়েছে:
- `FOREGROUND_SERVICE_DATA_SYNC` permission (Android 14+ এর জন্য)
- `directBootAware="true"` receivers এ (device boot হওয়ার আগেই alarms activate হবে)
- `LOCKED_BOOT_COMPLETED` action (encrypted devices এর জন্য)
- Receivers এর জন্য `enabled="true"` explicitly set করা হয়েছে

```xml
<!-- নতুন permission -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />

<!-- Improved receivers -->
<receiver 
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver" 
    android:exported="false"
    android:directBootAware="true"
    android:enabled="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.LOCKED_BOOT_COMPLETED" />
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON" />
    </intent-filter>
</receiver>
```

### 2. notification_service.dart Updates

#### পরিবর্তন:
- `uiLocalNotificationDateInterpretation` parameter যোগ করা হয়েছে
- এটি নিশ্চিত করে যে scheduled time সঠিকভাবে interpret হয়
- `AndroidScheduleMode.exactAllowWhileIdle` ব্যবহার করা হচ্ছে যা device doze mode এ থাকলেও alarm trigger করবে

```dart
await _notificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduleTime,
  platformDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  matchDateTimeComponents: DateTimeComponents.time,
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
);
```

### 3. home_screen.dart Updates

#### নতুন Instructions যোগ করা হয়েছে:
- **Samsung devices**: "Remove notification when app is closed" setting disable করার instruction
- **Xiaomi/Redmi**: Lockscreen notifications enable করার instruction
- **General devices**: Autostart enable করার instruction
- Main dialog text update করা হয়েছে: "even when removed from recent apps" mention করা হয়েছে

## Testing Instructions (পরীক্ষা করার নিয়ম)

### পদক্ষেপ ১: App Rebuild করুন
```bash
flutter clean
flutter pub get
flutter run
```

### পদক্ষেপ ২: Permissions Setup করুন
1. App খুলুন
2. Battery optimization dialog দেখলে "Allow" click করুন
3. Phone-specific settings complete করুন (যদি দেখায়)

### পদক্ষেপ ৩: Test Alarm Set করুন
1. Prayer Screen এ যান
2. একটি alarm set করুন (2-3 মিনিট পরের জন্য)
3. App থেকে বেরিয়ে যান
4. Recent apps থেকে app clear করুন (swipe করে)
5. অপেক্ষা করুন alarm এর জন্য

### পদক্ষেপ ৪: Samsung Specific (যদি Samsung phone হয়)
1. Settings → Apps → Daily Devotional → Notifications
2. "Remove notification when app is closed" → **DISABLE করুন** ✅
3. এটা খুবই গুরুত্বপূর্ণ Samsung devices এর জন্য

### পদক্ষেপ ৫: Xiaomi/Redmi Specific
1. Settings → Apps → Manage Apps → Daily Devotional
2. "Autostart" → Enable ✅
3. "Battery Saver" → "No restrictions" ✅
4. Settings → Notifications → Daily Devotional → "Allow notifications on lockscreen" ✅

## কেন এই সমস্যা হয়?

Android এর বিভিন্ন manufacturers (Samsung, Xiaomi, Oppo etc.) খুব aggressive battery optimization করে। যখন আপনি app clear করেন:
1. App এর process kill হয়ে যায়
2. কিছু devices scheduled alarms cancel করে দেয়
3. Background tasks stop হয়ে যায়

## আমাদের Fix কিভাবে কাজ করে?

1. **Direct Boot Awareness**: Device boot হওয়ার আগেই alarms restore হবে
2. **Exact Alarm Scheduling**: `exactAllowWhileIdle` mode ব্যবহার করে doze mode bypass করে
3. **Multiple Boot Receivers**: বিভিন্ন boot events listen করে (BOOT_COMPLETED, LOCKED_BOOT_COMPLETED etc.)
4. **Foreground Service Permission**: Android 14+ এর জন্য required
5. **User Instructions**: Brand-specific settings এর জন্য clear instructions

## যদি এখনও কাজ না করে?

### Option 1: Manual Battery Settings
```
Settings → Battery → Battery Optimization
→ Daily Devotional → Don't Optimize
```

### Option 2: Autostart Permission (Xiaomi/Oppo/Vivo)
```
Settings → Apps → Autostart
→ Daily Devotional → Enable
```

### Option 3: Samsung - Never Sleeping Apps
```
Settings → Battery → Background Usage Limits
→ Never Sleeping Apps → Add Daily Devotional
```

### Option 4: Check Notification Permissions
```
Settings → Apps → Daily Devotional → Permissions
→ Notifications → Allow
```

## Important Notes

1. **প্রথমবার install করার পর** সব permissions দিন যাতে alarms properly কাজ করে
2. **App update করার পর** alarms automatically restore হবে (MY_PACKAGE_REPLACED receiver এর জন্য)
3. **Device restart করার পর** সব alarms restore হবে (BOOT_COMPLETED receiver এর জন্য)
4. **Battery সাশ্রয়ী mode** এ থাকলেও alarms trigger হবে

## Technical Details

### Permissions Used:
- `SCHEDULE_EXACT_ALARM`: Exact time এ alarm trigger করার জন্য
- `USE_EXACT_ALARM`: Android 13+ এর জন্য
- `RECEIVE_BOOT_COMPLETED`: Boot পরে alarms restore করার জন্য
- `WAKE_LOCK`: Device sleep mode থেকে জাগানোর জন্য
- `FOREGROUND_SERVICE_DATA_SYNC`: Background এ reliably কাজ করার জন্য
- `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`: Battery optimization থেকে exempt হওয়ার জন্য

### Notification Flags:
- `FLAG_INSISTENT (4)`: Alarm user dismiss না করা পর্যন্ত ring করবে
- `FLAG_SHOW_WHEN_LOCKED (268435456)`: Lockscreen এ show হবে
- `FLAG_TURN_SCREEN_ON (2097152)`: Screen on করবে

---

**সর্বশেষ আপডেট**: March 9, 2026
**Status**: ✅ Fixed - Ready for testing
