import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rutino/screens/focus/service/notification_router_manager.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../libs.dart'; // Make sure this imports HabitModel

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  final SendPort? sendPort = IsolateNameServer.lookupPortByName(
    'water_updates',
  );
  if (sendPort != null) {
    sendPort.send(notificationResponse.actionId);
    return;
  }

  if (notificationResponse.actionId == 'drink_250') {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitModelAdapter());
    }
    await Hive.openBox<HabitModel>('habits');
    await Hive.openBox('stats');

    final habitBox = Hive.box<HabitModel>('habits');
    final habit = habitBox.get('1');
    if (habit != null) {
      if (habit.completedCount < habit.targetCount) {
        habit.completedCount += 250;
        if (habit.completedCount >= habit.targetCount) {
          habit.completedCount = habit.targetCount;
          final statsBox = Hive.box('stats');
          int currentXp = statsBox.get('xpLevel', defaultValue: 0);
          statsBox.put('xpLevel', currentXp + 10);
        }
        await habitBox.put('1', habit);
      }
    }
  } else if (notificationResponse.actionId == 'snooze_15') {
    NotificationService.snoozeWaterNotification();
  } else if (notificationResponse.actionId == 'action_stop') {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitModelAdapter());
    }
    await Hive.openBox<HabitModel>('habits');
    await Hive.openBox('stats');

    final habitBox = Hive.box<HabitModel>('habits');
    final habit = habitBox.get('2'); // Meditation habit ID
    if (habit != null) {
      if (habit.completedCount < habit.targetCount) {
        habit.completedCount = habit.targetCount;
        final statsBox = Hive.box('stats');
        int currentXp = statsBox.get('xpLevel', defaultValue: 0);
        statsBox.put('xpLevel', currentXp + 20); // Bonus XP
      }
      await habitBox.put('2', habit);
    }
  } else if (notificationResponse.actionId == 'action_freeze_workout') {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitModelAdapter());
    }
    await Hive.openBox<HabitModel>('habits');
    await Hive.openBox('stats');

    final statsBox = Hive.box('stats');
    int currentFreezes = statsBox.get('freezeBank', defaultValue: 0);
    if (currentFreezes > 0) {
      statsBox.put('freezeBank', currentFreezes - 1);
      final habitBox = Hive.box<HabitModel>('habits');
      final habit = habitBox.get('4');
      if (habit != null) {
        habit.completedCount = habit.targetCount;
        await habitBox.put('4', habit);
      }
    }
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> requestPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showTimerCompleteNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'timer_channel_id',
          'Timer Notifications',
          channelDescription: 'Notifications for Focus Room timer completions',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id: 0,
      title: 'Session Complete! 🎯',
      body: 'Your focus session has ended. Great job!',
      notificationDetails: platformChannelSpecifics,
    );
  }

  static NotificationDetails _waterNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'water_reminder_channel_v2',
        'Water Reminders',
        channelDescription: 'Notifications for daily water intake tracker',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(
          'mixkit_clear_announce_tones_2861',
        ),
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'drink_250',
            'Drink 250ml',
            showsUserInterface: false,
          ),
          AndroidNotificationAction(
            'snooze_15',
            'Snooze (15 Mins)',
            showsUserInterface: false,
          ),
        ],
      ),
    );
  }

  static Future<void> snoozeWaterNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    final snoozeTime = now.add(const Duration(minutes: 15));

    await _notificationsPlugin.zonedSchedule(
      id: 9999, // Unique ID for snooze
      title: '💧 Snooze Over!',
      body: 'Time to drink a glass of water.',
      scheduledDate: snoozeTime,
      notificationDetails: _waterNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    await NotificationRouterManager().scheduleNativeSystemAlarm(
      scheduledTime: snoozeTime,
      habitId: 'water_tracker',
      title: '💧 Snooze Over!',
      body: 'Time to drink a glass of water.',
      emoji: '💧',
    );
  }

  // static Future<void> scheduleTestNotification() async {
  //   final now = tz.TZDateTime.now(tz.local);
  //   final testTime = now.add(const Duration(seconds: 5));
  //
  //   await _notificationsPlugin.zonedSchedule(
  //     id: 9998,
  //     title: '💧 Test Reminder!',
  //     body: 'This is a test notification. Sound is working!',
  //     scheduledDate: testTime,
  //     notificationDetails: _waterNotificationDetails(),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //   );
  // }

  static Future<void> cancelAllWaterNotifications() async {
    for (int i = 2000; i <= 2100; i++) {
      await _notificationsPlugin.cancel(id: i);
    }
    await _notificationsPlugin.cancel(id: 9999); // Snooze
  }

  static Future<void> scheduleWaterReminders(List<String> times) async {
    await cancelAllWaterNotifications();

    for (String timeStr in times) {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]) ?? 8;
        final minute = int.tryParse(parts[1]) ?? 0;

        for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
          final scheduledDate = _nextInstanceOfTime(
            hour,
            minute,
          ).add(Duration(days: dayOffset));
          await NotificationRouterManager().scheduleNativeSystemAlarm(
            scheduledTime: scheduledDate,
            habitId: 'water_tracker_${hour}_${minute}_$dayOffset',
            title: '💧 Water Time!',
            body:
                'Stay hydrated! Drink a glass of water to reach your daily goal.',
            emoji: '💧',
          );
        }
      }
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> cancelMeditationNotifications() async {
    for (int i = 3000; i <= 3010; i++) {
      await _notificationsPlugin.cancel(id: i);
    }
  }

  static Future<void> scheduleMeditationReminders(
    String timeStr,
    List<int> daysList,
  ) async {
    await cancelMeditationNotifications();

    final timeParts = timeStr.split(':');
    if (timeParts.length != 2) return;

    final hour = int.tryParse(timeParts[0]) ?? 6;
    final minute = int.tryParse(timeParts[1]) ?? 30;

    for (int day in daysList) {
      for (int week = 0; week < 4; week++) {
        final scheduledDate = _nextInstanceOfDayAndTime(
          day,
          hour,
          minute,
        ).add(Duration(days: 7 * week));
        await NotificationRouterManager().scheduleNativeSystemAlarm(
          scheduledTime: scheduledDate,
          habitId: 'meditation_${day}_$week',
          title: '🧘‍♂️ Mindful Moment',
          body: 'It is time for your meditation. Take a deep breath.',
          emoji: '🧘‍♂️',
        );
      }
    }
  }

  static tz.TZDateTime _nextInstanceOfDayAndTime(
    int day,
    int hour,
    int minute,
  ) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> cancelBookNotifications() async {
    for (int i = 4000; i <= 4010; i++) {
      await _notificationsPlugin.cancel(id: i);
    }
  }

  static Future<void> scheduleBookReminders(
    String timeStr,
    List<int> daysList,
    String bookName,
  ) async {
    await cancelBookNotifications();

    final timeParts = timeStr.split(':');
    if (timeParts.length != 2) return;

    final hour = int.tryParse(timeParts[0]) ?? 21;
    final minute = int.tryParse(timeParts[1]) ?? 30;

    for (int day in daysList) {
      for (int week = 0; week < 4; week++) {
        final scheduledDate = _nextInstanceOfDayAndTime(
          day,
          hour,
          minute,
        ).add(Duration(days: 7 * week));
        await NotificationRouterManager().scheduleNativeSystemAlarm(
          scheduledTime: scheduledDate,
          habitId: 'book_${day}_$week',
          title: '📖 Reading Time',
          body: 'Time to read $bookName. Let\'s make some progress!',
          emoji: '📖',
        );
      }
    }
  }

  static Future<void> cancelWorkoutNotifications() async {
    for (int i = 5000; i <= 5010; i++) {
      await _notificationsPlugin.cancel(id: i);
    }
  }

  static Future<void> scheduleWorkoutReminders(
    String timeStr,
    List<int> daysList,
    String workoutName,
  ) async {
    await cancelWorkoutNotifications();

    final timeParts = timeStr.split(':');
    if (timeParts.length != 2) return;

    final hour = int.tryParse(timeParts[0]) ?? 18;
    final minute = int.tryParse(timeParts[1]) ?? 30;

    for (int day in daysList) {
      for (int week = 0; week < 4; week++) {
        final scheduledDate = _nextInstanceOfDayAndTime(
          day,
          hour,
          minute,
        ).add(Duration(days: 7 * week));
        await NotificationRouterManager().scheduleNativeSystemAlarm(
          scheduledTime: scheduledDate,
          habitId: 'workout_${day}_$week',
          title: '🏋️‍♂️ Time to Sweat!',
          body: 'Pack your gym bag! Time for $workoutName.',
          emoji: '🏋️‍♂️',
        );
      }
    }
  }
}
