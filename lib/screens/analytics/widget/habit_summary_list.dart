import '../../../../libs.dart';

class HabitSummaryList extends StatelessWidget {
  const HabitSummaryList({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardState = Provider.of<DashboardViewModel>(context);
    final theme = Provider.of<ThemeChangerViewModel>(context);

    final habits = dashboardState.habits;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final rate = habit.targetCount > 0
            ? (habit.completedCount / habit.targetCount).clamp(0.0, 1.0)
            : 0.0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.getCardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.getSecondaryTextColor.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              habit.icon.customTextStyle(fontSize: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    habit.title.blackTextStyle(
                      color: theme.getTextColor,
                      fw: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: rate,
                      backgroundColor: theme.getScaffoldColor,
                      color: theme.getSuccessColor,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              "${(rate * 100).toStringAsFixed(0)}%".primaryTextStyle(
                color: theme.getPrimaryColor,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.large,
              ),
            ],
          ),
        );
      },
    );
  }
}
