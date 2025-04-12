import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MemorialNotifications {
  // 🕯️ Daily Memorial Notification at 10:00 AM
  Future<void> scheduleDailyReminder() async {
    final now = DateTime.now();
    final reminderTime = DateTime(now.year, now.month, now.day, 10, 0);
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(reminderTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      11,
      'In Loving Memory 🕊️',
      'Remembering Keneni today.',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Memorial',
          channelDescription: 'Daily tribute to Keneni',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  // 🕯️ Weekly Memorial Notification at 9:00 AM on Mondays
  Future<void> scheduleWeeklyReminder() async {
    final now = DateTime.now();
    final nextMonday = now.add(Duration(days: (7 - now.weekday) % 7));
    final reminderTime = DateTime(nextMonday.year, nextMonday.month, nextMonday.day, 9, 0);
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(reminderTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      12,
      'Weekly Memorial 🕊️',
      'Remembering Keneni this week.',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_channel',
          'Weekly Memorial',
          channelDescription: 'Weekly tribute to Keneni',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  // 🕯️ Monthly Memorial Notification at 9:00 AM on the 1st of every month
  Future<void> scheduleMonthlyReminder() async {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1, 9, 0);
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(firstOfMonth, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      13,
      'Monthly Memorial 🕊️',
      'Remembering Keneni this month.',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'monthly_channel',
          'Monthly Memorial',
          channelDescription: 'Monthly tribute to Keneni',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }
}
