import 'package:intl/intl.dart';

import '../../../../libs.dart';

class WeeklyCalendar extends StatefulWidget {
  const WeeklyCalendar({super.key});

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final dashboardState = Provider.of<DashboardViewModel>(context);
    final selectedDate = dashboardState.selectedDate;
    final now = DateTime.now();

    // Generate a simple list of 7 days around today
    List<DateTime> weekDates = List.generate(7, (index) {
      return now.subtract(Duration(days: 3 - index));
    });

    final List<String> dayNames = ["M", "T", "W", "T", "F", "S", "S"];

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
            child: DateFormat('MMMM yyyy')
                .format(selectedDate)
                .blackTextStyle(color: theme.getTextColor, fw: FontWeight.bold),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = weekDates[index];
                final isSelected = date.year == selectedDate.year && 
                                   date.month == selectedDate.month && 
                                   date.day == selectedDate.day;

                return GestureDetector(
                  onTap: () {
                    dashboardState.setSelectedDate(date);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    width: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.getPrimaryColor
                          : theme.getCardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? theme.getPrimaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dayNames[date.weekday - 1].greyTextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.getSecondaryTextColor,
                          fw: FontWeight.w600,
                        ),
                        const SizedBox(height: 8),
                        date.day.toString().blackTextStyle(
                          color: isSelected ? Colors.white : theme.getTextColor,
                          fw: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
