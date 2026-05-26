import 'package:rutino/screens/focus/widget/in_app_reminder_overlay.dart';

import '../../../libs.dart';

class NotificationRouterManager with WidgetsBindingObserver {
  static final NotificationRouterManager _instance =
      NotificationRouterManager._internal();
  factory NotificationRouterManager() => _instance;
  NotificationRouterManager._internal() {
    WidgetsBinding.instance.addObserver(this);
    isAppInForeground =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _initNativeActionListener();
  }

  bool isAppInForeground = false;
  BuildContext? currentAppContext;
  static const MethodChannel _channel = MethodChannel('com.aks.rutino/alarm');

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isAppInForeground = state == AppLifecycleState.resumed;
  }

  // Global Setup to track App Active States (Context)
  void updateAppContext(BuildContext context) {
    currentAppContext = context;
  }

  // Listens for actions passed from Native Android (e.g. Slide to Done)
  Future<void> _initNativeActionListener() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'showInAppReminder') {
        final Map<dynamic, dynamic> args = call.arguments;
        handleIncomingRoutineAlert(
          title: args['title'] ?? 'Reminder',
          body: args['body'] ?? '',
          emoji: args['emoji'] ?? '🔥',
          habitId: args['habitId'] ?? '',
        );
      } else if (call.method == 'markHabitDone') {
        final Map<dynamic, dynamic> args = call.arguments;
        final habitId = args['habitId'];
        if (habitId != null) {
          _markHabitDone(habitId);
        }
      }
    });

    // Check periodically or once on startup
    try {
      final result = await _channel.invokeMethod('checkPendingActions');
      if (result != null) {
        final action = result['action'];
        final habitId = result['habitId'];
        if (action == 'mark_done' && habitId != null) {
          _markHabitDone(habitId);
        }
      }
    } catch (e) {
      debugPrint("Error checking pending native actions: $e");
    }
  }

  void _markHabitDone(String fullHabitId) {
    String habitId = fullHabitId;
    if (fullHabitId.contains('water_tracker')) habitId = '1';
    else if (fullHabitId.contains('meditation')) habitId = '2';
    else if (fullHabitId.contains('book')) habitId = '3';
    else if (fullHabitId.contains('workout')) habitId = '4';

    if (currentAppContext != null) {
      final dashboardState = Provider.of<DashboardViewModel>(
        currentAppContext!,
        listen: false,
      );
      final habit = dashboardState.habits.firstWhere((h) => h.id == habitId);
      
      int amount = habit.targetCount;
      if (habitId == '1') {
        amount = 250;
      }
      
      dashboardState.incrementHabit(habitId, amount);
      CustomToast.showSuccess(
        currentAppContext!,
        habitId == '1' ? "+250ml Added" : "Habit Completed",
        "Marked done from lock screen!",
      );
    } else {
      // Fallback if no context: direct hive update
      final box = Hive.box<HabitModel>('habits');
      final habit = box.get(habitId);
      if (habit != null) {
        int amount = habit.targetCount;
        if (habitId == '1') {
          amount = 250;
        }
        
        habit.completedCount += amount;
        if (habit.completedCount >= habit.targetCount) {
          habit.completedCount = habit.targetCount;
          String todayStr = DateTime.now().toString().split(' ')[0];
          Hive.box('logs_box').put('${habitId}_$todayStr', true);
        }
        box.put(habitId, habit);
      }
    }
  }

  // Core execution engine when time triggers
  void handleIncomingRoutineAlert({
    required String habitId,
    required String title,
    required String body,
    required String emoji,
  }) {
    if (isAppInForeground && currentAppContext != null) {
      showGeneralDialog(
        context: currentAppContext!,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, anim1, anim2) {
          return InAppReminderOverlay(
            title: title,
            description: body,
            emoji: emoji,
            onDone: () {
              Navigator.pop(context);
              _markHabitDone(habitId);
            },
            onDismiss: () {
              Navigator.pop(context);
              CustomToast.showWarning(
                context,
                "Snoozed",
                "Reminding you in 15 minutes",
              );
            },
          );
        },
      );
    } else {
      _triggerNativeSystemAlarm(title, body, emoji, habitId);
    }
  }

  Future<void> _triggerNativeSystemAlarm(
    String title,
    String body,
    String emoji,
    String habitId,
  ) async {
    try {
      await _channel.invokeMethod('triggerNativeAlarm', {
        'title': title,
        'body': body,
        'emoji': emoji,
        'habitId': habitId,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to trigger native alarm: '${e.message}'.");
    }
  }

  Future<void> scheduleNativeSystemAlarm({
    required DateTime scheduledTime,
    required String habitId,
    required String title,
    required String body,
    required String emoji,
  }) async {
    try {
      await _channel.invokeMethod('scheduleNativeAlarm', {
        'timeMs': scheduledTime.millisecondsSinceEpoch,
        'title': title,
        'body': body,
        'emoji': emoji,
        'habitId': habitId,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to schedule native alarm: '${e.message}'.");
    }
  }
}
