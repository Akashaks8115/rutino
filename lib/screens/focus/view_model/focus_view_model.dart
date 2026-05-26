import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:audioplayers/audioplayers.dart';
import '../model/focus_log_model.dart';
import '../service/notification_service.dart';

enum FocusMode { study, meditate, reading }

class FocusViewModel extends ChangeNotifier {
  late Box<FocusLogModel> _focusBox;
  late Box _statsBox;

  FocusMode _currentMode = FocusMode.study;
  FocusMode get currentMode => _currentMode;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  DateTime? _startTime;
  int _targetSeconds = 25 * 60; // Default 25 min
  int _remainingSeconds = 25 * 60;
  
  int get remainingSeconds => _remainingSeconds;
  int get targetSeconds => _targetSeconds;
  
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  FocusViewModel() {
    _focusBox = Hive.box<FocusLogModel>('focusLogs');
    _statsBox = Hive.box('stats');
    _checkOfflineState();
  }

  void _checkOfflineState() {
    final savedStartTime = _statsBox.get('focusStartTime');
    final savedTarget = _statsBox.get('focusTargetSeconds');
    final savedMode = _statsBox.get('focusModeIndex');

    if (savedStartTime != null && savedTarget != null) {
      _startTime = DateTime.fromMillisecondsSinceEpoch(savedStartTime);
      _targetSeconds = savedTarget;
      _currentMode = FocusMode.values[savedMode ?? 0];
      
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      if (elapsed < _targetSeconds) {
        _remainingSeconds = _targetSeconds - elapsed;
        _startInternalTimer();
      } else {
        _remainingSeconds = 0;
        _clearOfflineState();
      }
    }
  }

  void setMode(FocusMode mode) {
    if (_isRunning) return;
    _currentMode = mode;
    if (mode == FocusMode.study) {
      setTargetTime(25);
    } else if (mode == FocusMode.meditate) {
      setTargetTime(10);
    } else if (mode == FocusMode.reading) {
      setTargetTime(30);
    }
    notifyListeners();
  }

  void setTargetTime(int minutes) {
    if (_isRunning) return;
    _targetSeconds = minutes * 60;
    _remainingSeconds = _targetSeconds;
    notifyListeners();
  }

  void startTimer() {
    if (_isRunning || _remainingSeconds <= 0) return;
    
    if (_startTime == null) {
      _startTime = DateTime.now();
      _statsBox.put('focusStartTime', _startTime!.millisecondsSinceEpoch);
      _statsBox.put('focusTargetSeconds', _targetSeconds);
      _statsBox.put('focusModeIndex', _currentMode.index);
    }

    if (_currentMode == FocusMode.meditate) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _audioPlayer.play(AssetSource('music/maditation.mp3'));
    } else if (_currentMode == FocusMode.reading) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _audioPlayer.play(AssetSource('music/readBook.mp3'));
    }

    _startInternalTimer();
  }

  void _startInternalTimer() {
    _isRunning = true;
    notifyListeners();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      _remainingSeconds = _targetSeconds - elapsed;

      if (_remainingSeconds <= 0) {
        _remainingSeconds = 0;
        timer.cancel();
        _isRunning = false;
        _audioPlayer.stop();
        _clearOfflineState();
        NotificationService.showTimerCompleteNotification();
        _addFocusTreeXp();
      }
      notifyListeners();
    });
  }

  void pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    _isRunning = false;
    _audioPlayer.pause();
    
    final elapsed = _targetSeconds - _remainingSeconds;
    _targetSeconds = _remainingSeconds;
    _startTime = null; 
    _clearOfflineState();
    
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _audioPlayer.stop();
    _startTime = null;
    setMode(_currentMode); // resets to default duration
    _clearOfflineState();
    notifyListeners();
  }

  void _clearOfflineState() {
    _statsBox.delete('focusStartTime');
    _statsBox.delete('focusTargetSeconds');
    _statsBox.delete('focusModeIndex');
  }

  void _addFocusTreeXp() {
    int currentXp = _statsBox.get('xpLevel', defaultValue: 0);
    _statsBox.put('xpLevel', currentXp + 50); 
  }

  void saveSessionLog(String rating) {
    final durationMins = _targetSeconds ~/ 60;
    final log = FocusLogModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mode: _currentMode.name,
      durationMinutes: durationMins,
      timestamp: DateTime.now(),
      rating: rating,
    );
    _focusBox.add(log);
    setMode(_currentMode);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
