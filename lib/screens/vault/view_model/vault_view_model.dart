import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'package:local_auth/local_auth.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../libs.dart';

class VaultViewModel extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricEnabled = false;

  // Gamification
  int _xp = 0;
  int _coins = 0;

  bool get isBiometricEnabled => _isBiometricEnabled;
  int get xp => _xp;
  int get coins => _coins;
  int get level => (_xp ~/ 500) + 1;
  double get levelProgress => (_xp % 500) / 500.0;

  StreamSubscription? _statsSub;

  VaultViewModel() {
    _initData();
    _statsSub = Hive.box('stats').watch().listen((event) {
      if (event.key == 'xpLevel' || event.key == 'coins') {
        _initData();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _statsSub?.cancel();
    super.dispose();
  }

  void _initData() {
    final prefsBox = Hive.box('prefs');
    _isBiometricEnabled = prefsBox.get('biometric_lock', defaultValue: false);

    final statsBox = Hive.box('stats');
    _xp = statsBox.get('xpLevel', defaultValue: 0);
    _coins = statsBox.get('coins', defaultValue: 0);
  }

  // Called to add XP
  void addXP(int amount) {
    _xp += amount;
    _coins += (amount * 0.1).toInt(); // 1 coin per 10 XP

    final statsBox = Hive.box('stats');
    statsBox.put('xpLevel', _xp);
    statsBox.put('coins', _coins);
    notifyListeners();
  }

  Future<void> toggleBiometricLock(bool value, BuildContext context) async {
    if (value) {
      final isAvailable = await auth.canCheckBiometrics;
      if (!isAvailable) {
        CustomToast.showWarning(context, "Unavailable", "Biometrics not available on this device");
        return;
      }
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to enable App Lock',
      );
      if (!authenticated) return;
    }

    _isBiometricEnabled = value;
    Hive.box('prefs').put('biometric_lock', value);
    notifyListeners();
  }

  Future<void> exportBackup(BuildContext context) async {
    try {
      Map<String, dynamic> fullBackup = {
        'habits': Hive.box<HabitModel>('habits').toMap(),
        'focus': Hive.box<FocusLogModel>('focusLogs').toMap(),
        'stats': Hive.box('stats').toMap(),
      };

      String jsonString = jsonEncode(fullBackup);
      final directory = await getTemporaryDirectory();
      final path = "${directory.path}/rutino_backup.json";
      final file = File(path);
      await file.writeAsString(jsonString);

      if (!context.mounted) return;
      await Share.shareXFiles([XFile(path)], text: 'Rutino Offline Backup');
    } catch (e) {
      if (!context.mounted) return;
      CustomToast.showWarning(context, "Failed", "Backup failed");
    }
  }

  Future<void> importBackup(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String jsonString = await file.readAsString();
        Map<String, dynamic> backup = jsonDecode(jsonString);

        // Restore
        final habitsBox = Hive.box<HabitModel>('habits');
        final focusBox = Hive.box<FocusLogModel>('focusLogs');
        final statsBox = Hive.box('stats');

        await habitsBox.clear();
        if (backup['habits'] != null) {
          (backup['habits'] as Map).forEach((k, v) => habitsBox.put(k, v));
        }

        await focusBox.clear();
        if (backup['focus'] != null) {
          (backup['focus'] as Map).forEach((k, v) => focusBox.put(k, v));
        }

        await statsBox.clear();
        if (backup['stats'] != null) {
          (backup['stats'] as Map).forEach((k, v) => statsBox.put(k, v));
        }

        _initData(); // refresh

        if (!context.mounted) return;
        CustomToast.showSuccess(context, "Success", "Backup Restored Successfully!");
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomToast.showWarning(context, "Failed", "Restore failed or Invalid JSON");
    }
  }
}
