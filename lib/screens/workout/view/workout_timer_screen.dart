import 'dart:async';
import '../../../../libs.dart';

class WorkoutTimerScreen extends StatefulWidget {
  final HabitModel habit;
  const WorkoutTimerScreen({super.key, required this.habit});

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  int _secondsRemaining = 0;
  int _totalSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.habit.targetCount * 60;
    _secondsRemaining = _totalSeconds;
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _onTimerComplete() {
    HapticFeedback.heavyImpact();
    _showNoteDialog();
  }

  void _showNoteDialog() {
    showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: Colors.transparent,
       builder: (ctx) => WorkoutNoteDialog(
          habit: widget.habit,
          minutesTrained: (_totalSeconds - _secondsRemaining) / 60.0,
       ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neonCrimson = const Color(0xFFFF4500);

    String minutesStr = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (_secondsRemaining % 60).toString().padLeft(2, '0');

    return CommonScreen(
      showBannerAd: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Workout Active".customTextStyle(color: Colors.white, fw: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: _totalSeconds == 0 ? 0 : 1 - (_secondsRemaining / _totalSeconds),
                    strokeWidth: 15,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(neonCrimson),
                  ),
                ),
                Text(
                  "$minutesStr:$secondsStr",
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: neonCrimson,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonCrimson,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                    ),
                    onPressed: _startTimer,
                    child: const Icon(BootstrapIcons.play_fill, color: Colors.white, size: 32),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                    ),
                    onPressed: _pauseTimer,
                    child: const Icon(BootstrapIcons.pause_fill, color: Colors.white, size: 32),
                  ),
                const SizedBox(width: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  onPressed: () {
                     _pauseTimer();
                     _showNoteDialog();
                  },
                  child: const Icon(BootstrapIcons.stop_fill, color: Colors.white, size: 32),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
