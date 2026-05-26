import '../libs.dart';

class RoutesName {
  static const String splash = 'splash_view';
  static const String onboarding = 'onboarding';
  static const String bottomNav = 'bottom_nav';
  static const String waterIntake = '/waterIntake';
  static const String challengeRoom = '/challengeRoom';
  static const String challengeDetail = '/challengeDetail';
  static const String meditation = 'meditation';
  static const String bookReading = 'book_reading';
  static const String workoutSetup = 'workout_setup';
  static const String sleepTracker = 'sleep_tracker';
}

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );

      case RoutesName.onboarding:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OnboardingScreen(),
        );

      case RoutesName.bottomNav:
        return MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavScreen(),
        );

      case RoutesName.waterIntake:
        return MaterialPageRoute(builder: (context) => const WaterIntakeScreen());
      case RoutesName.meditation:
        return MaterialPageRoute(builder: (context) => const MeditationScreen());
      case RoutesName.bookReading:
        return MaterialPageRoute(builder: (context) => const BookReadingScreen());
      case RoutesName.workoutSetup:
        return MaterialPageRoute(builder: (context) => const WorkoutSetupScreen());
      case RoutesName.challengeRoom:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const ChallengeRoomScreen(),
        );
      case RoutesName.challengeDetail:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ChallengeDetailScreen(challengeId: settings.arguments as String),
        );
      case RoutesName.sleepTracker:
        return MaterialPageRoute(
          builder: (context) => const SleepTrackerScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('No route defined')),
            );
          },
        );
    }
  }
}
