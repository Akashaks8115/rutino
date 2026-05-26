import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../libs.dart';

class ChallengeRoomScreen extends StatelessWidget {
  const ChallengeRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final challengeVM = Provider.of<ChallengeViewModel>(context);

    return CommonScreen(
      showBannerAd: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Challenge Room".blackTextStyle(
          color: theme.getTextColor,
          fw: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: theme.getTextColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Accept a challenge to test your discipline.".greyTextStyle(
            color: theme.getSecondaryTextColor,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: challengeVM.allChallenges.length,
              itemBuilder: (context, index) {
                final challenge = challengeVM.allChallenges[index];
                bool isActive = challenge.status == 'ongoing';
                bool isFailed = challenge.status == 'failed';
                bool isCompleted = challenge.status == 'completed';

                double progress = challenge.durationDays > 0
                    ? (challenge.currentDayNumber / challenge.durationDays)
                          .clamp(0.0, 1.0)
                    : 0.0;

                Color statusColor = theme.getPrimaryColor;
                if (isActive) statusColor = AppColor.orangeColor;
                if (isFailed) statusColor = Colors.redAccent;
                if (isCompleted) statusColor = theme.getSuccessColor;

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesName.challengeDetail,
                      arguments: challenge.id,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.getCardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: isActive
                          ? Border.all(
                              color: statusColor.withValues(alpha: 0.5),
                              width: 2,
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 8.0,
                          percent: progress,
                          center: isActive
                              ? Center(
                                  child: Text(
                                    "${challenge.currentDayNumber}\nDays",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : isFailed
                              ? Icon(Icons.close, color: statusColor, size: 30)
                              : isCompleted
                              ? Icon(Icons.check, color: statusColor, size: 30)
                              : Icon(
                                  Icons.lock_outline,
                                  color: theme.getSecondaryTextColor,
                                  size: 30,
                                ),
                          progressColor: statusColor,
                          backgroundColor: theme.getScaffoldColor,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        const SizedBox(height: 16),
                        challenge.title.blackTextStyle(
                          color: theme.getTextColor,
                          fw: FontWeight.bold,
                          align: TextAlign.center,
                          overflow: TextOverflow.clip,
                          enumFontSize: EnumFontSize.small,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: challenge.difficulty.primaryTextStyle(
                            color: statusColor,
                            enumFontSize: EnumFontSize.extraSmall,
                            fw: FontWeight.w500,
                            overflow: TextOverflow.clip,
                          ),
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
