import 'package:fl_chart/fl_chart.dart';

import '../../../../libs.dart';

class PerformanceCharts extends StatelessWidget {
  const PerformanceCharts({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AnalyticsViewModel>(context);
    final theme = Provider.of<ThemeChangerViewModel>(context);

    if (state.isLoading || state.weeklyData.isEmpty) {
      return const SizedBox();
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.getCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.getSecondaryTextColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Weekly Performance".blackTextStyle(
            color: theme.getTextColor,
            fw: FontWeight.bold,
            enumFontSize: EnumFontSize.large,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('M', style: style);
                            break;
                          case 1:
                            text = const Text('T', style: style);
                            break;
                          case 2:
                            text = const Text('W', style: style);
                            break;
                          case 3:
                            text = const Text('T', style: style);
                            break;
                          case 4:
                            text = const Text('F', style: style);
                            break;
                          case 5:
                            text = const Text('S', style: style);
                            break;
                          case 6:
                            text = const Text('S', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(meta: meta, child: text);
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: state.weeklyData.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: theme.getPrimaryColor,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
