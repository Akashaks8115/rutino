import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rutino/libs.dart';
import '../model/challenge_model.dart';

class ChallengeViewModel extends ChangeNotifier {
  late Box<ChallengeModel> _challengesBox;
  late Box _logsBox;
  late Box<HabitModel> _habitBox;
  late Box _prefsBox;

  ChallengeViewModel() {
    _challengesBox = Hive.box<ChallengeModel>('challenges_box');
    _logsBox = Hive.box('logs_box');
    _habitBox = Hive.box<HabitModel>('habits');
    _prefsBox = Hive.box('prefs');
    
    _initPredefinedChallenges();
    verifyActiveChallenges();
  }

  void _initPredefinedChallenges() {
    if (_challengesBox.isEmpty) {
      _challengesBox.put('challenge_morning_monk', ChallengeModel(
        id: 'challenge_morning_monk',
        title: 'The Morning Monk Bootcamp',
        durationDays: 21,
        linkedHabitIds: ['wake_up', '2'], // '2' is Meditation
        rewardXP: 500,
        description: 'Target: Wake up early and meditate.\nDaily Tasks: Wake up at 5:30 AM + Meditate 15 Mins.',
        difficulty: 'Hard',
      ));
      _challengesBox.put('challenge_digital_detox', ChallengeModel(
        id: 'challenge_digital_detox',
        title: 'The Digital Detox Challenge',
        durationDays: 7,
        linkedHabitIds: ['no_screen', '3'], // '3' is Read Book
        rewardXP: 250,
        description: 'Target: Reduce screen time.\nDaily Tasks: No Screen after 9:30 PM + Read Book.',
        difficulty: 'Medium',
      ));
      _challengesBox.put('challenge_75_hard_light', ChallengeModel(
        id: 'challenge_75_hard_light',
        title: '75-Hard Light Routine',
        durationDays: 45,
        linkedHabitIds: ['1', '4', 'no_junk'], // '1' Water, '4' Workout
        rewardXP: 1000,
        description: 'Target: Overall life discipline.\nDaily Tasks: Drink Water + 45 Mins Workout + No Junk Food.',
        difficulty: 'Insane',
      ));
    }
  }

  List<ChallengeModel> get allChallenges => _challengesBox.values.toList();
  
  List<ChallengeModel> get activeChallenges => 
      _challengesBox.values.where((c) => c.status == 'ongoing').toList();

  void acceptChallenge(BuildContext context, String challengeId) {
    final challenge = _challengesBox.get(challengeId);
    if (challenge != null) {
      challenge.status = 'ongoing';
      challenge.startDate = DateTime.now().toString().split(' ')[0];
      challenge.currentDayNumber = 1;
      challenge.lastCheckInDate = challenge.startDate;
      
      _challengesBox.put(challengeId, challenge);
      
      // Auto-add habits to Dashboard
      final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
      for (String habitId in challenge.linkedHabitIds) {
         if (!dashboardVM.enabledFeatures.contains(habitId)) {
            // Provide a default template if not exists
            HabitModel template;
            if (habitId == 'wake_up') {
              template = HabitModel(id: habitId, title: 'Wake up 5:30 AM', completedCount: 0, targetCount: 1, timeOfDay: 'Morning', icon: '🌅', type: HabitType.yesNo);
            } else if (habitId == 'no_screen') {
              template = HabitModel(id: habitId, title: 'No Screen post 9:30PM', completedCount: 0, targetCount: 1, timeOfDay: 'Evening', icon: '📵', type: HabitType.yesNo);
            } else if (habitId == 'no_junk') {
              template = HabitModel(id: habitId, title: 'No Junk Food', completedCount: 0, targetCount: 1, timeOfDay: 'Afternoon', icon: '🥗', type: HabitType.yesNo);
            } else if (habitId == '1') {
              template = HabitModel(id: habitId, title: 'Drink Water', completedCount: 0, targetCount: 3500, timeOfDay: 'Morning', icon: '💧', type: HabitType.quantifiable);
            } else if (habitId == '2') {
              template = HabitModel(id: habitId, title: 'Meditation', completedCount: 0, targetCount: 1, timeOfDay: 'Morning', icon: '🧘', type: HabitType.yesNo);
            } else if (habitId == '3') {
              template = HabitModel(id: habitId, title: 'Read Book', completedCount: 0, targetCount: 15, timeOfDay: 'Evening', icon: '📚', type: HabitType.quantifiable);
            } else if (habitId == '4') {
              template = HabitModel(id: habitId, title: 'Workout', completedCount: 0, targetCount: 45, timeOfDay: 'Morning', icon: '🏋️', type: HabitType.quantifiable);
            } else {
              template = HabitModel(id: habitId, title: 'Task $habitId', completedCount: 0, targetCount: 1, timeOfDay: 'Morning', icon: '✨', type: HabitType.yesNo);
            }
            dashboardVM.toggleFeature(habitId, true, template);
         }
      }
      
      notifyListeners();
    }
  }

  void verifyActiveChallenges() {
    String todayStr = DateTime.now().toString().split(' ')[0];
    String yesterdayStr = DateTime.now().subtract(const Duration(days: 1)).toString().split(' ')[0];

    bool changed = false;

    for (var key in _challengesBox.keys) {
      var challenge = _challengesBox.get(key);
      if (challenge == null || challenge.status != 'ongoing') continue;

      // Check if they missed yesterday
      bool yesterdayAllDone = true;
      for (String habitId in challenge.linkedHabitIds) {
        String logId = "${habitId}_$yesterdayStr";
        var log = _logsBox.get(logId);
        if (log == null || log == false) {
          yesterdayAllDone = false;
          break;
        }
      }

      if (!yesterdayAllDone && challenge.lastCheckInDate != yesterdayStr && challenge.startDate != todayStr) {
        // Failed
        challenge.status = 'failed';
        challenge.currentDayNumber = 0;
        _challengesBox.put(key, challenge);
        changed = true;
      } else {
        // If they did it or it's a new day
        if (challenge.lastCheckInDate == yesterdayStr && challenge.lastCheckInDate != todayStr) {
          // Did they do yesterday? Yes, because yesterdayAllDone is true or handled
          challenge.currentDayNumber += 1;
          challenge.lastCheckInDate = todayStr; // wait, lastCheckInDate is when they complete today!
          
          if (challenge.currentDayNumber > challenge.durationDays) {
            challenge.status = 'completed';
            // Add XP
            var statsBox = Hive.box('stats');
            int currentXp = statsBox.get('xpLevel', defaultValue: 0);
            statsBox.put('xpLevel', currentXp + challenge.rewardXP);
          }
          _challengesBox.put(key, challenge);
          changed = true;
        }
      }
    }
    if (changed) notifyListeners();
  }
}
