import '../../../../libs.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final state = Provider.of<AnalyticsViewModel>(context);

    return CommonScreen(
      showBannerAd: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CompAppBar.titleBar(
          title: "Analytics Room",
          isBackButtonVisible: false,
          // Note: export action was removed because titleBar doesn't support actions easily yet.
          // (Assuming CompAppBar.titleBar doesn't have an actions property)
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Consistency Heatmap (Last 365 Days)".greyTextStyle(
              color: theme.getSecondaryTextColor,
              fw: FontWeight.bold,
            ),
            const HeatmapCalendar(),

            const SizedBox(height: 24),

            if (!state.isLoading) ...[
              "Insight: Your best day is ${state.bestDay}, and your weakest is ${state.worstDay}."
                  .primaryTextStyle(
                    color: theme.getPrimaryColor,
                    overflow: TextOverflow.clip,
                    fw: FontWeight.w500,
                  ),
              const SizedBox(height: 16),
            ],

            const PerformanceCharts(),

            const SizedBox(height: 32),

            "Habit Success Rates".greyTextStyle(
              color: theme.getSecondaryTextColor,
              fw: FontWeight.bold,
            ),
            const HabitSummaryList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
