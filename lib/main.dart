import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:toastification/toastification.dart';

import 'libs.dart';
import 'screens/explore/model/challenge_model.dart';
import 'screens/explore/view_model/challenge_view_model.dart';
import 'screens/steps/model/step_log_model.dart';
import 'screens/steps/viewmodel/step_tracker_view_model.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Hive.initFlutter();
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(FocusLogModelAdapter());
  Hive.registerAdapter(WorkoutLogModelAdapter());
  Hive.registerAdapter(ChallengeModelAdapter());
  Hive.registerAdapter(StepLogModelAdapter());
  await Hive.openBox<HabitModel>('habits');
  await Hive.openBox('stats');
  await Hive.openBox<FocusLogModel>('focusLogs');
  await Hive.openBox('workout_logs');
  await Hive.openBox('prefs');
  await Hive.openBox<ChallengeModel>('challenges_box');
  await Hive.openBox('logs_box');
  await Hive.openBox('sleep_logs');
  await Hive.openBox<StepLogModel>('steps_log_box');

  await Hive.openBox('water_settings');
  await Hive.openBox('meditation_settings');

  final ReceivePort port = ReceivePort();
  IsolateNameServer.registerPortWithName(port.sendPort, 'water_updates');
  port.listen((dynamic data) {
    if (data == 'drink_250') {
      final context = navigatorKey.currentContext;
      if (context != null) {
        Provider.of<WaterIntakeViewModel>(
          context,
          listen: false,
        ).logWater(250, context);
      }
    } else if (data == 'snooze_15') {
      NotificationService.snoozeWaterNotification();
    } else if (data == 'action_book_timer') {
      final context = navigatorKey.currentContext;
      if (context != null) {
        Provider.of<FocusViewModel>(context, listen: false).setMode(FocusMode.reading);
        CustomToast.showInfo(context, "Focus Mode Updated", "Focus Mode set to Reading. Go to Focus Tab!");
      }
    } else if (data == 'action_start_workout') {
      final context = navigatorKey.currentContext;
      if (context != null) {
        final habitBox = Hive.box<HabitModel>('habits');
        final workoutHabit = habitBox.get('4');
        if (workoutHabit != null && workoutHabit.workoutGoalType == 'duration') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutTimerScreen(habit: workoutHabit)));
        } else if (workoutHabit != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => WorkoutNoteDialog(habit: workoutHabit, minutesTrained: 0),
            );
        }
      }
    } else if (data == 'action_freeze_workout') {
      final statsBox = Hive.box('stats');
      int currentFreezes = statsBox.get('freezeBank', defaultValue: 0);
      if (currentFreezes > 0) {
         statsBox.put('freezeBank', currentFreezes - 1);
         final habitBox = Hive.box<HabitModel>('habits');
         final habit = habitBox.get('4');
         if(habit != null) {
            habit.completedCount = habit.targetCount;
            habitBox.put('4', habit);
            final context = navigatorKey.currentContext;
            if (context != null) {
               Provider.of<DashboardViewModel>(context, listen: false).refresh();
            }
         }
      }
    }
  });

  await NotificationService.initialize();

  MobileAds.instance.initialize();
  tz.initializeTimeZones();
  try {
    final TimezoneInfo timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    String tzName = timeZoneInfo.identifier;
    
    // Map legacy or deprecated timezone names
    if (tzName == 'Asia/Calcutta') tzName = 'Asia/Kolkata';
    if (tzName == 'Asia/Rangoon') tzName = 'Asia/Yangon';
    
    tz.setLocalLocation(tz.getLocation(tzName));
  } catch (e) {
    try {
      tz.setLocalLocation(tz.getLocation('UTC'));
    } catch (_) {}
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharedPrefViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeChangerViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => FocusViewModel()),
        ChangeNotifierProvider(create: (_) => AnalyticsViewModel()),
        ChangeNotifierProvider(create: (_) => MeditationViewModel()),
        ChangeNotifierProvider(create: (_) => BookReadingViewModel()),
        ChangeNotifierProvider(create: (_) => WorkoutViewModel()),
        ChangeNotifierProvider(create: (_) => VaultViewModel()),
        ChangeNotifierProvider(create: (_) => WaterIntakeViewModel()),
        ChangeNotifierProvider(create: (_) => ChallengeViewModel()),
        ChangeNotifierProvider(create: (_) => SleepTrackerViewModel()),
        ChangeNotifierProvider(create: (_) => StepTrackerViewModel()),
      ],
      child: Consumer<ThemeChangerViewModel>(
        builder: (context, provider, child) {
          return ToastificationWrapper(
            child: MaterialApp(
              navigatorKey: navigatorKey,
              title: Constants.appName,
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
              themeMode: provider.getThemeMode,
              theme: provider.getThemeData,
              darkTheme: provider.getThemeData,
              initialRoute: RoutesName.splash,
              onGenerateRoute: Routes.generateRoute,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
