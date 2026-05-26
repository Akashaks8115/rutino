import 'package:local_auth/local_auth.dart';
import '../../../libs.dart';

class SplashService {
  static final sharedPrefViewModel = Provider.of<SharedPrefViewModel>(
    navigatorKey.currentContext!,
    listen: false,
  );

  static Future<void> call() async {
    final prefsBox = Hive.box('prefs');
    String? userName = prefsBox.get('user_name');
    
    if (userName == null || userName.isEmpty) {
      Navigator.pushReplacementNamed(
        navigatorKey.currentContext!,
        RoutesName.onboarding,
      );
      return;
    }

    bool isLocked = prefsBox.get('biometric_lock', defaultValue: false);

    if (isLocked) {
      final LocalAuthentication auth = LocalAuthentication();
      try {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Authenticate to unlock Rutino',
        );
        if (!didAuthenticate) {
          return; // Stay on splash screen if failed/cancelled
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      RoutesName.bottomNav,
    );
  }

  static Future<void> callLogout() async {}
}
