import '../../../../libs.dart';

class SleepTrackerScreen extends StatelessWidget {
  const SleepTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final sleepVM = Provider.of<SleepTrackerViewModel>(context);

    // Provide the start date (1 year ago from today, aligned to Sunday)
    final today = DateTime.now();
    final yearAgo = today.subtract(const Duration(days: 365));
    // Find the Sunday of that week
    final startDate = yearAgo.subtract(Duration(days: yearAgo.weekday % 7));

    return CommonScreen(
      showBannerAd: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CompAppBar.titleBar(
          title: "Sleep Heatmap",
          isBackButtonVisible: true,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Row(
            children: [
              Icon(Icons.nights_stay, color: theme.getPrimaryColor, size: 28),
              const SizedBox(width: 8),
              "365-Days Sleep Quality".blackTextStyle(
                color: theme.getTextColor,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.large,
              ),
            ],
          ),
          const SizedBox(height: 8),
          "A complete visualization of your sleep consistency over the past year."
              .primaryTextStyle(
                color: theme.getSecondaryTextColor,
                enumFontSize: EnumFontSize.small,
                overflow: TextOverflow.clip,
                fw: FontWeight.normal,
              ),
          const SizedBox(height: 32),

          // Heatmap Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.getCardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.getPrimaryColor.withValues(alpha: 0.1)),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Y-Axis Labels (Days of Week)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          right: 8,
                        ), // Offset for X-Axis labels
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var i = 0; i < 7; i++)
                              Container(
                                height: 16,
                                margin: const EdgeInsets.only(bottom: 4),
                                child: Center(
                                  child:
                                      (i % 2 == 0
                                              ? [
                                                  "Sun",
                                                  "Mon",
                                                  "Tue",
                                                  "Wed",
                                                  "Thu",
                                                  "Fri",
                                                  "Sat",
                                                ][i]
                                              : "")
                                          .greyTextStyle(
                                            color: theme.getSecondaryTextColor,
                                            enumFontSize:
                                                EnumFontSize.extraSmall,
                                          ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Mathematical Grid: 52 Weeks (Columns) x 7 Days (Rows)
                      Row(
                        children: List.generate(53, (colIndex) {
                          // Month Labeling Logic (Basic)
                          final columnStartDate = startDate.add(
                            Duration(days: colIndex * 7),
                          );
                          bool isFirstWeekOfMonth = columnStartDate.day <= 7;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // X-Axis Label (Month)
                              SizedBox(
                                height: 20,
                                child: isFirstWeekOfMonth
                                    ? [
                                            "Jan",
                                            "Feb",
                                            "Mar",
                                            "Apr",
                                            "May",
                                            "Jun",
                                            "Jul",
                                            "Aug",
                                            "Sep",
                                            "Oct",
                                            "Nov",
                                            "Dec",
                                          ][columnStartDate.month - 1]
                                          .greyTextStyle(
                                            color: theme.getSecondaryTextColor,
                                            enumFontSize:
                                                EnumFontSize.extraSmall,
                                          )
                                    : const SizedBox(),
                              ),

                              // 7 Days of the week
                              for (var rowIndex = 0; rowIndex < 7; rowIndex++)
                                () {
                                  final cellDate = startDate.add(
                                    Duration(days: (colIndex * 7) + rowIndex),
                                  );
                                  if (cellDate.isAfter(today)) {
                                    // Future date
                                    return Container(
                                      width: 16,
                                      height: 16,
                                      margin: const EdgeInsets.only(
                                        right: 4,
                                        bottom: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    );
                                  }

                                  int minutes = sleepVM.getSleepDurationForDate(
                                    cellDate,
                                  );
                                  Color cellColor = sleepVM.getColorForDuration(
                                    minutes,
                                    theme.getPrimaryColor,
                                  );

                                  return Tooltip(
                                    message:
                                        "${cellDate.year}-${cellDate.month.toString().padLeft(2, '0')}-${cellDate.day.toString().padLeft(2, '0')}: ${minutes ~/ 60}h ${minutes % 60}m",
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      margin: const EdgeInsets.only(
                                        right: 4,
                                        bottom: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cellColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  );
                                }(),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    "Less".greyTextStyle(
                      color: theme.getSecondaryTextColor,
                      enumFontSize: EnumFontSize.extraSmall,
                    ),
                    const SizedBox(width: 8),
                    _buildLegendCell(Colors.grey.withValues(alpha: 0.1)), // None
                    _buildLegendCell(Colors.red.withValues(alpha: 0.5)), // Poor (<4h)
                    _buildLegendCell(
                      theme.getPrimaryColor.withValues(alpha: 0.5),
                    ), // Okay (<7h)
                    _buildLegendCell(theme.getPrimaryColor), // Optimal (7-10h)
                    _buildLegendCell(
                      theme.getPrimaryColor.withValues(alpha: 0.8),
                    ), // Over (>10h)
                    const SizedBox(width: 8),
                    "More".greyTextStyle(
                      color: theme.getSecondaryTextColor,
                      enumFontSize: EnumFontSize.extraSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Date-wise Bar Graph for Last 7 Days
          _buildBarChart(theme, sleepVM, today),

          const SizedBox(height: 32),

          // Small summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.getPrimaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.getPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_graph, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Consistent Sleep".blackTextStyle(
                        color: theme.getTextColor,
                        fw: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      "Aim for the dark blue cells (7+ hours) every night to maximize your XP and health."
                          .primaryTextStyle(
                            color: theme.getSecondaryTextColor,
                            enumFontSize: EnumFontSize.small,
                            overflow: TextOverflow.clip,
                            fw: FontWeight.normal,
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(
    ThemeChangerViewModel theme,
    SleepTrackerViewModel sleepVM,
    DateTime today,
  ) {
    final List<DateTime> last7Days = List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );

    int maxMinutes = 480;
    for (var date in last7Days) {
      final mins = sleepVM.getSleepDurationForDate(date);
      if (mins > maxMinutes) {
        maxMinutes = mins;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.getCardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.getPrimaryColor.withValues(alpha: 0.1)),
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
          Row(
            children: [
              Icon(Icons.bar_chart, color: theme.getPrimaryColor, size: 20),
              const SizedBox(width: 8),
              "Last 7 Days".blackTextStyle(
                color: theme.getTextColor,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.medium,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: last7Days.map((date) {
                final mins = sleepVM.getSleepDurationForDate(date);
                final hours = mins / 60.0;
                final heightRatio = mins / maxMinutes;
                final dayStr = [
                  "Mon",
                  "Tue",
                  "Wed",
                  "Thu",
                  "Fri",
                  "Sat",
                  "Sun",
                ][date.weekday - 1];
                final barColor = sleepVM.getColorForDuration(
                  mins,
                  theme.getPrimaryColor,
                );

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (mins > 0)
                        "${hours.toStringAsFixed(1)}h".greyTextStyle(
                          color: theme.getSecondaryTextColor,
                          enumFontSize: EnumFontSize.extraSmall,
                        ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 24,
                        height: mins == 0
                            ? 4
                            : 100 * heightRatio, // Max height 100
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      dayStr.greyTextStyle(
                        color: theme.getTextColor,
                        enumFontSize: EnumFontSize.extraSmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCell(Color color) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
