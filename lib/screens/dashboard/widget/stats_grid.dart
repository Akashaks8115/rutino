import '../../../libs.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);

    return Consumer<DashboardViewModel>(
      builder: (context, dashboardState, child) {
        List<Widget> cards = [];

        if (dashboardState.streakCount > 0) {
          cards.add(
            _StatCard(
              title: "Streak Counter",
              value: "🔥 ${dashboardState.streakCount} Days",
              theme: theme,
            ),
          );
        }

        if (dashboardState.xpLevel > 0) {
          cards.add(
            _StatCard(
              title: "XP Level",
              value: "⚡ ${dashboardState.xpLevel} XP",
              theme: theme,
            ),
          );
        }

        cards.add(
          _StatCard(
            title: "Daily Progress",
            value:
                "🎯 ${dashboardState.completedHabitsCount}/${dashboardState.totalHabitsCount} Done",
            theme: theme,
          ),
        );

        if (dashboardState.freezeBank > 0) {
          cards.add(
            _StatCard(
              title: "Freeze Bank",
              value: "🧊 ${dashboardState.freezeBank} Left",
              theme: theme,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: cards,
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final ThemeChangerViewModel theme;

  const _StatCard({
    required this.title,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.getCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.getPrimaryColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title.greyTextStyle(
            color: theme.getSecondaryTextColor,
            fw: FontWeight.w600,
            enumFontSize: EnumFontSize.small,
          ),
          const SizedBox(height: 8),
          value.blackTextStyle(
            color: theme.getTextColor,
            fw: FontWeight.bold,
            enumFontSize: EnumFontSize.large,
          ),
        ],
      ),
    );
  }
}
