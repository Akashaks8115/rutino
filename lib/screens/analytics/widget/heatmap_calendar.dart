import '../../../../libs.dart';

class HeatmapCalendar extends StatelessWidget {
  const HeatmapCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AnalyticsViewModel>(context);
    final theme = Provider.of<ThemeChangerViewModel>(context);

    if (state.isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final sortedDates = state.heatmapData.keys.toList()..sort();

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // Start at the most recent dates
        child: Wrap(
          direction: Axis.vertical,
          spacing: 4,
          runSpacing: 4,
          children: sortedDates.map((date) {
            final rate = state.heatmapData[date]!;

            Color blockColor = theme.getCardColor;
            if (rate > 0 && rate <= 0.4) {
              blockColor = theme.getSuccessColor.withValues(alpha: 0.3);
            } else if (rate > 0.4 && rate <= 0.8) {
              blockColor = theme.getSuccessColor.withValues(alpha: 0.6);
            } else if (rate > 0.8) {
              blockColor = theme.getSuccessColor;
            }

            return GestureDetector(
              onTap: () {
                CustomToast.showInfo(
                  context,
                  "Completion Rate",
                  '${date.toIso8601String().split('T').first}: ${(rate * 100).toStringAsFixed(0)}%',
                );
              },
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: blockColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
