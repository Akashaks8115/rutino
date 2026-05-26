import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../libs.dart';

class TimerRing extends StatelessWidget {
  const TimerRing({super.key});

  @override
  Widget build(BuildContext context) {
    final focusState = Provider.of<FocusViewModel>(context);
    final theme = Provider.of<ThemeChangerViewModel>(context);

    double percent = 1.0;
    if (focusState.targetSeconds > 0) {
      percent = focusState.remainingSeconds / focusState.targetSeconds;
      percent = percent.clamp(0.0, 1.0);
    }

    String timeDisplay = _formatTime(focusState.remainingSeconds);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: focusState.isRunning
            ? [
                BoxShadow(
                  color: theme.getPrimaryColor.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ]
            : [],
      ),
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 12.0,
        percent: percent,
        animation: true,
        animateFromLastPercent: true,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: theme.getCardColor,
        progressColor: theme.getPrimaryColor,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            timeDisplay.customTextStyle(
              fontSize: 48,
              fw: FontWeight.bold,
              color: theme.getTextColor,
            ),
            const SizedBox(height: 8),
            (focusState.isRunning ? "Focusing..." : "Ready").greyTextStyle(
              color: theme.getSecondaryTextColor,
              enumFontSize: EnumFontSize.large,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int m = totalSeconds ~/ 60;
    int s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
