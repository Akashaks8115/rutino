
import '../../../../libs.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  bool _wasRunning = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final focusState = Provider.of<FocusViewModel>(context);

    // Dialog triggering logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_wasRunning &&
          !focusState.isRunning &&
          focusState.remainingSeconds == 0) {
        showSessionFeedbackDialog(context, focusState);
      }
      _wasRunning = focusState.isRunning;
    });

    return CommonScreen(
      showBannerAd: false,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              _buildModeSwitcher(theme, focusState),
              const Spacer(),
              if (focusState.currentMode == FocusMode.meditate)
                const BreathingGuide()
              else
                const TimerRing(),
              const Spacer(),
              _buildControls(theme, focusState),
              const SizedBox(height: 40),
              _buildFocusTree(theme, focusState), // Gamification
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSwitcher(ThemeChangerViewModel theme, FocusViewModel state) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.getCardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: FocusMode.values.map((mode) {
          final isSelected = state.currentMode == mode;
          return GestureDetector(
            onTap: () => state.setMode(mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? theme.getPrimaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: mode.name.toUpperCase().blackTextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.getSecondaryTextColor,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.small,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildControls(ThemeChangerViewModel theme, FocusViewModel state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state.isRunning || state.remainingSeconds < state.targetSeconds)
          IconButton(
            onPressed: () => state.resetTimer(),
            icon: const Icon(BootstrapIcons.arrow_counterclockwise),
            color: theme.getTextColor,
            iconSize: 32,
          ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () {
            HapticFeedback.heavyImpact();
            if (state.isRunning) {
              state.pauseTimer();
            } else {
              state.startTimer();
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state.isRunning
                  ? theme.getCardColor
                  : theme.getPrimaryColor,
              border: Border.all(
                color: theme.getPrimaryColor,
                width: state.isRunning ? 2 : 0,
              ),
            ),
            child: Icon(
              state.isRunning
                  ? BootstrapIcons.pause_fill
                  : BootstrapIcons.play_fill,
              color: state.isRunning ? theme.getPrimaryColor : Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 24),
        if (state.isRunning || state.remainingSeconds < state.targetSeconds)
          const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildFocusTree(ThemeChangerViewModel theme, FocusViewModel state) {
    final statsBox = Hive.box('stats');
    int xp = statsBox.get('xpLevel', defaultValue: 0);

    String treeIcon = "🌱";
    if (xp > 1500) treeIcon = "🌿";
    if (xp > 2000) treeIcon = "🌳";

    return Column(
      children: [
        treeIcon.customTextStyle(fontSize: 32),
        const SizedBox(height: 8),
        "Focus Tree Level ${(xp / 100).floor()}".greyTextStyle(
          color: theme.getSecondaryTextColor,
          enumFontSize: EnumFontSize.small,
          fw: FontWeight.bold,
        ),
      ],
    );
  }
}
