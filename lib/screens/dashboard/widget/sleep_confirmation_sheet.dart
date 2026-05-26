import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../libs.dart'; // Ensure correct import for ThemeChangerViewModel and other utilities if needed

class SleepConfirmationSheet extends StatefulWidget {
  final DateTime bedTime;
  final DateTime wakeTime;
  final int totalMinutes;
  final Function(DateTime, DateTime, int) onConfirm;

  const SleepConfirmationSheet({
    super.key,
    required this.bedTime,
    required this.wakeTime,
    required this.totalMinutes,
    required this.onConfirm,
  });

  @override
  State<SleepConfirmationSheet> createState() => _SleepConfirmationSheetState();
}

class _SleepConfirmationSheetState extends State<SleepConfirmationSheet> {
  late DateTime _currentBedTime;
  late DateTime _currentWakeTime;

  @override
  void initState() {
    super.initState();
    _currentBedTime = widget.bedTime;
    _currentWakeTime = widget.wakeTime;
  }

  int get _calculatedMinutes {
    return _currentWakeTime.difference(_currentBedTime).inMinutes;
  }

  String _formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    return "${hours}h ${mins}m";
  }

  Future<void> _pickTime(bool isBedTime) async {
    final initialTime = isBedTime ? _currentBedTime : _currentWakeTime;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );
    if (time != null) {
      setState(() {
        if (isBedTime) {
          _currentBedTime = DateTime(
            _currentBedTime.year,
            _currentBedTime.month,
            _currentBedTime.day,
            time.hour,
            time.minute,
          );
          // Handle day boundary if bedtime is suddenly set after midnight but previous was before
          if (_currentBedTime.isAfter(_currentWakeTime)) {
             _currentBedTime = _currentBedTime.subtract(const Duration(days: 1));
          }
        } else {
          _currentWakeTime = DateTime(
            _currentWakeTime.year,
            _currentWakeTime.month,
            _currentWakeTime.day,
            time.hour,
            time.minute,
          );
          if (_currentWakeTime.isBefore(_currentBedTime)) {
            _currentWakeTime = _currentWakeTime.add(const Duration(days: 1));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String userName = Hive.box('prefs').get('user_name', defaultValue: 'User');

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(Icons.nights_stay, size: 48, color: Color(0xFF6B4EE6)),
          const SizedBox(height: 16),
          Text(
            "Good Morning, $userName! ☀️",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "It looks like you slept for ${_formatDuration(_calculatedMinutes)} last night. Is this correct?",
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeCard("Bedtime", _currentBedTime, () => _pickTime(true)),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              _buildTimeCard("Wake up", _currentWakeTime, () => _pickTime(false)),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4EE6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                widget.onConfirm(_currentBedTime, _currentWakeTime, _calculatedMinutes);
                Navigator.pop(context);
              },
              child: const Text(
                "Yes, Confirm! (+15 XP) 👍",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String label, DateTime time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  DateFormat.jm().format(time),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 14, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
