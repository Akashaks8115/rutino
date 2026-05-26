import '../../../../libs.dart';

class BreathingGuide extends StatefulWidget {
  const BreathingGuide({super.key});

  @override
  State<BreathingGuide> createState() => _BreathingGuideState();
}

class _BreathingGuideState extends State<BreathingGuide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // 4s inhale, 4s exhale
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final focusState = Provider.of<FocusViewModel>(context);

    if (!focusState.isRunning) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 0.6 + (_controller.value * 0.4); 
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.getPrimaryColor.withValues(alpha: 0.15),
                ),
              ),
            ),
            Transform.scale(
              scale: scale * 0.9,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.getPrimaryColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.getPrimaryColor.withValues(alpha: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: theme.getPrimaryColor.withValues(alpha: 0.5),
                    blurRadius: 20,
                  )
                ]
              ),
              child: Center(
                child: (!focusState.isRunning 
                        ? "Ready" 
                        : (_controller.status == AnimationStatus.forward ? "Inhale" : "Exhale")).customTextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fw: FontWeight.bold,
                  ),
              ),
            ),
          ],
        );
      },
    );
  }
}
