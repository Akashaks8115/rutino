import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../libs.dart';

class ActiveChallengesGrid extends StatelessWidget {
  const ActiveChallengesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeVM = Provider.of<ChallengeViewModel>(context);
    final theme = Provider.of<ThemeChangerViewModel>(context);

    // Show active and completed challenges
    final myChallenges = challengeVM.allChallenges
        .where((c) => c.status == 'ongoing' || c.status == 'completed')
        .toList();

    if (myChallenges.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child:
              "No active or completed challenges yet.\nVisit Explore to accept one!"
                  .greyTextStyle(
                    color: theme.getSecondaryTextColor,
                    align: TextAlign.center,
                  ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: myChallenges.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final challenge = myChallenges[index];
          final bool isCompleted = challenge.status == 'completed';
          double progress = challenge.durationDays > 0
              ? (challenge.currentDayNumber / challenge.durationDays).clamp(
                  0.0,
                  1.0,
                )
              : 0.0;

          Color statusColor = isCompleted
              ? theme.getSuccessColor
              : AppColor.orangeColor;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutesName.challengeDetail,
                arguments: challenge.id,
              );
            },
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.getCardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 5.0,
                    percent: progress,
                    center: isCompleted
                        ? Icon(Icons.check, color: statusColor, size: 20)
                        : Text(
                            "${challenge.currentDayNumber}d",
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                    progressColor: statusColor,
                    backgroundColor: theme.getScaffoldColor,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(height: 12),
                  challenge.title.blackTextStyle(
                    align: TextAlign.center,
                    color: theme.getTextColor,
                    enumFontSize: EnumFontSize.extraSmall,
                    fw: FontWeight.w500,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
