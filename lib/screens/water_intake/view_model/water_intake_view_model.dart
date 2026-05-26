import '../../../../libs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterIntakeViewModel extends ChangeNotifier {
  final String _habitId = '1';
  late Box<HabitModel> _habitBox;
  late Box _settingsBox;

  HabitModel? get waterHabit => _habitBox.get(_habitId);

  String get reminderMode => _settingsBox.get('reminderMode', defaultValue: 'specific');
  int get intervalMinutes => _settingsBox.get('intervalMinutes', defaultValue: 90);
  List<String> get specificTimes => List<String>.from(_settingsBox.get('specificTimes', defaultValue: ['09:00', '14:00', '19:00']));

  WaterIntakeViewModel() {
    _habitBox = Hive.box<HabitModel>('habits');
    _settingsBox = Hive.box('water_settings');
    _ensureHabitExists();
  }

  void _ensureHabitExists() {
    if (!_habitBox.containsKey(_habitId)) {
      _habitBox.put(_habitId, HabitModel(
        id: _habitId, 
        title: 'Drink Water', 
        completedCount: 0, 
        targetCount: 3500, 
        timeOfDay: 'Morning', 
        icon: '💧', 
        type: HabitType.quantifiable
      ));
    }
  }

  void updateTarget(int newTarget, BuildContext context) async {
    final habit = waterHabit;
    if (habit != null) {
      habit.targetCount = newTarget;
      if (habit.completedCount > habit.targetCount) {
         habit.completedCount = habit.targetCount;
      }
      _habitBox.put(_habitId, habit);
      notifyListeners();
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('water_target', newTarget);
      
      if (!context.mounted) return;
      Provider.of<DashboardViewModel>(context, listen: false).refresh();
    }
  }

  void setReminderMode(String mode) {
    _settingsBox.put('reminderMode', mode);
    notifyListeners();
  }

  void addSpecificTime(String time) {
    List<String> times = specificTimes;
    if (!times.contains(time)) {
      times.add(time);
      _settingsBox.put('specificTimes', times);
      notifyListeners();
    }
  }

  void removeSpecificTime(String time) {
    List<String> times = specificTimes;
    times.remove(time);
    _settingsBox.put('specificTimes', times);
    notifyListeners();
  }

  void saveAndScheduleReminders() async {
    List<String> timesToSchedule = [];

    if (reminderMode == 'specific') {
      timesToSchedule = specificTimes;
    } else {
      // Logic for interval
      // Simplified: Just add times from 8 AM to 8 PM every intervalMinutes
      int currentMinutes = 8 * 60; // 8:00 AM
      int endMinutes = 20 * 60; // 8:00 PM

      while (currentMinutes <= endMinutes) {
        int hour = currentMinutes ~/ 60;
        int minute = currentMinutes % 60;
        timesToSchedule.add('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
        currentMinutes += intervalMinutes;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('water_reminders', timesToSchedule.join(','));
    
    // Calculate increment amount (e.g. 500ml default, or target / count)
    int target = waterHabit?.targetCount ?? 3000;
    int increment = timesToSchedule.isNotEmpty ? (target ~/ timesToSchedule.length) : 500;
    prefs.setInt('water_increment', increment);

    await NotificationService.scheduleWaterReminders(timesToSchedule);
  }

  void logWater(int amount, BuildContext context) {
    final habit = waterHabit;
    if (habit != null) {
      if (habit.completedCount >= habit.targetCount) return;

      habit.completedCount += amount;
      if (habit.completedCount >= habit.targetCount) {
        habit.completedCount = habit.targetCount;
        final statsBox = Hive.box('stats');
        int currentXp = statsBox.get('xpLevel', defaultValue: 0);
        statsBox.put('xpLevel', currentXp + 10);
      }
      _habitBox.put(_habitId, habit);
      notifyListeners();

      Provider.of<DashboardViewModel>(context, listen: false).refresh();
    }
  }
}
