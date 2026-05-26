import 'package:confetti/confetti.dart';

import '../../../libs.dart';

class HabitList extends StatelessWidget {
  const HabitList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);

    return Consumer<DashboardViewModel>(
      builder: (context, dashboardState, child) {
        final habits = dashboardState.habits;

        if (habits.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(
                  BootstrapIcons.inbox,
                  size: 48,
                  color: theme.getSecondaryTextColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                "No features active yet.".blackTextStyle(
                  color: theme.getTextColor,
                  fw: FontWeight.bold,
                ),
                const SizedBox(height: 8),
                "Go to 'Explore' to turn on tools\nlike Drink Water, Meditation, etc."
                    .greyTextStyle(
                      align: TextAlign.center,
                      color: theme.getSecondaryTextColor,
                    ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final habit = habits[index];
            return Dismissible(
              key: Key(habit.id),
              direction: DismissDirection.endToStart, // Right-to-left
              confirmDismiss: (direction) async {
                _showNoteDialog(context, habit, dashboardState, theme);
                return false;
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: theme.getPrimaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  BootstrapIcons.pencil_square, // Pen icon
                  color: Colors.white,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  if (habit.id == '1') {
                    Navigator.pushNamed(context, RoutesName.waterIntake);
                  }
                },
                child: _HabitCard(
                  habit: habit,
                  theme: theme,
                  dashboardState: dashboardState,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNoteDialog(
    BuildContext context,
    HabitModel habit,
    DashboardViewModel state,
    ThemeChangerViewModel theme,
  ) {
    final TextEditingController noteController = TextEditingController(
      text: habit.note,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.getCardColor,
          title: "Note for ${habit.title}".blackTextStyle(
            color: theme.getTextColor,
          ),
          content: TextField(
            controller: noteController,
            style: TextStyle(color: theme.getTextColor),
            decoration: InputDecoration(
              hintText: "Enter your short journal note...",
              hintStyle: TextStyle(color: theme.getSecondaryTextColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.getSecondaryTextColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.getPrimaryColor),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: "Cancel".greyTextStyle(color: theme.getSecondaryTextColor),
            ),
            TextButton(
              onPressed: () {
                state.saveNoteForHabit(habit.id, noteController.text);
                Navigator.pop(context);
                CustomToast.showSuccess(
                  context,
                  "Note Saved",
                  "Note saved locally!",
                );
              },
              child: "Save".primaryTextStyle(
                color: theme.getPrimaryColor,
                fw: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HabitCard extends StatefulWidget {
  final HabitModel habit;
  final ThemeChangerViewModel theme;
  final DashboardViewModel dashboardState;

  const _HabitCard({
    required this.habit,
    required this.theme,
    required this.dashboardState,
  });

  @override
  State<_HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<_HabitCard> {
  late ConfettiController _confettiController;
  bool _wasDone = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
    _wasDone = widget.habit.completedCount >= widget.habit.targetCount;
  }

  @override
  void didUpdateWidget(covariant _HabitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool isNowDone = widget.habit.completedCount >= widget.habit.targetCount;
    if (!_wasDone && isNowDone) {
      _confettiController.play();
    }
    _wasDone = isNowDone;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildBookIncrementBtn(
    BuildContext context,
    String text,
    int amount,
    bool isDone,
  ) {
    return InkWell(
      onTap: (isDone || !widget.dashboardState.isTodaySelected)
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.dashboardState.incrementHabit(widget.habit.id, amount);
            },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDone
              ? widget.theme.getSuccessColor
              : const Color(0xFFF59E0B).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDone
                ? Colors.transparent
                : const Color(0xFFF59E0B).withValues(alpha: 0.3),
          ),
        ),
        child: text.customTextStyle(
          color: isDone ? Colors.white : const Color(0xFFF59E0B),
          fw: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        widget.habit.completedCount / widget.habit.targetCount;
    final bool isDone = widget.habit.completedCount >= widget.habit.targetCount;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.theme.getCardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.theme.getPrimaryColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDone
                      ? widget.theme.getSuccessColor.withValues(alpha: 0.1)
                      : widget.theme.getScaffoldColor,
                  shape: BoxShape.circle,
                ),
                child: widget.habit.icon.customTextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
              // Title and Progress Bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.habit.title.blackTextStyle(
                      color: widget.theme.getTextColor,
                      fw: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    // Progress indicator
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: widget.theme.getScaffoldColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? widget.theme.getSuccessColor
                                  : widget.theme.getPrimaryColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    "${widget.habit.completedCount} / ${widget.habit.targetCount} ${widget.habit.id == '3' ? 'Pages' : ''}"
                        .greyTextStyle(
                          color: widget.theme.getSecondaryTextColor,
                        ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Action Buttons
              if (widget.habit.type == HabitType.yesNo)
                InkWell(
                  onTap: (isDone || !widget.dashboardState.isTodaySelected)
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          widget.dashboardState.incrementHabit(
                            widget.habit.id,
                            widget.habit.targetCount,
                          );
                        },
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone
                            ? widget.theme.getSuccessColor
                            : widget.theme.getPrimaryColor,
                        width: 2,
                      ),
                      color: isDone
                          ? widget.theme.getSuccessColor
                          : Colors.transparent,
                    ),
                    child: isDone
                        ? const Icon(
                            BootstrapIcons.check,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                )
              else if (widget.habit.id == '3')
                Row(
                  children: [
                    _buildBookIncrementBtn(context, "+1", 1, isDone),
                    const SizedBox(width: 8),
                    _buildBookIncrementBtn(context, "+5", 5, isDone),
                    const SizedBox(width: 8),
                    _buildBookIncrementBtn(context, "+10", 10, isDone),
                  ],
                )
              else if (widget.habit.id == '4')
                InkWell(
                  onTap: (isDone || !widget.dashboardState.isTodaySelected)
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          if (widget.habit.workoutGoalType == 'duration') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WorkoutTimerScreen(habit: widget.habit),
                              ),
                            );
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => WorkoutNoteDialog(
                                habit: widget.habit,
                                minutesTrained: 0,
                              ),
                            );
                          }
                        },
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone
                            ? widget.theme.getSuccessColor
                            : const Color(0xFFFF4500),
                        width: 2,
                      ),
                      color: isDone
                          ? widget.theme.getSuccessColor
                          : Colors.transparent,
                    ),
                    child: isDone
                        ? const Icon(
                            BootstrapIcons.check,
                            color: Colors.white,
                            size: 24,
                          )
                        : const Icon(
                            BootstrapIcons.play_fill,
                            color: Color(0xFFFF4500),
                            size: 20,
                          ),
                  ),
                )
              else
                Row(
                  children: [
                    // Minus
                    InkWell(
                      onTap: !widget.dashboardState.isTodaySelected ? null : () {
                        HapticFeedback.lightImpact();
                        int decrementAmount = widget.habit.targetCount > 100
                            ? 500
                            : 1;
                        widget.dashboardState.incrementHabit(
                          widget.habit.id,
                          -decrementAmount,
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.theme.getScaffoldColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          BootstrapIcons.dash,
                          color: widget.theme.getTextColor,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Plus
                    InkWell(
                      onTap: (isDone || !widget.dashboardState.isTodaySelected)
                          ? null
                          : () {
                              HapticFeedback.mediumImpact();
                              int incrementAmount =
                                  widget.habit.targetCount > 100 ? 500 : 1;
                              widget.dashboardState.incrementHabit(
                                widget.habit.id,
                                incrementAmount,
                              );
                            },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDone
                              ? widget.theme.getSuccessColor
                              : widget.theme.getPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isDone
                              ? BootstrapIcons.check_lg
                              : BootstrapIcons.plus_lg,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          particleDrag: 0.05,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          gravity: 0.05,
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
          ],
        ),
      ],
    );
  }
}
