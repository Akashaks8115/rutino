import '../../../../libs.dart';

class MeditationViewModel extends ChangeNotifier {
  late Box _meditationBox;

  List<int> _selectedDays = [1, 3, 5]; // Default Mon, Wed, Fri
  List<int> get selectedDays => _selectedDays;

  int _hour = 6;
  int _minute = 30;
  int get hour => _hour;
  int get minute => _minute;

  bool _isReminderEnabled = true;
  bool get isReminderEnabled => _isReminderEnabled;

  MeditationViewModel() {
    _meditationBox = Hive.box('meditation_settings');
    _loadSettings();
  }

  void _loadSettings() {
    _selectedDays = List<int>.from(_meditationBox.get('selectedDays', defaultValue: [1, 3, 5]));
    String timeStr = _meditationBox.get('reminderTime', defaultValue: '06:30');
    final parts = timeStr.split(':');
    if (parts.length == 2) {
      _hour = int.tryParse(parts[0]) ?? 6;
      _minute = int.tryParse(parts[1]) ?? 30;
    }
    _isReminderEnabled = _meditationBox.get('isReminderEnabled', defaultValue: true);
    notifyListeners();
  }

  void toggleDay(int day) {
    if (_selectedDays.contains(day)) {
      _selectedDays.remove(day);
    } else {
      _selectedDays.add(day);
    }
    notifyListeners();
  }

  void setTime(int h, int m) {
    _hour = h;
    _minute = m;
    notifyListeners();
  }

  void toggleReminder(bool value) {
    _isReminderEnabled = value;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    String timeStr = '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}';
    await _meditationBox.put('selectedDays', _selectedDays);
    await _meditationBox.put('reminderTime', timeStr);
    await _meditationBox.put('isReminderEnabled', _isReminderEnabled);

    if (_isReminderEnabled) {
      await NotificationService.scheduleMeditationReminders(timeStr, _selectedDays);
    } else {
      await NotificationService.cancelMeditationNotifications();
    }
    notifyListeners();
  }
}
