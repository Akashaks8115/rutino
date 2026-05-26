import '../../../../libs.dart';

class ChallengeDetailScreen extends StatelessWidget {
  final String challengeId;
  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final challengeVM = Provider.of<ChallengeViewModel>(context);

    final challenge = challengeVM.allChallenges.firstWhere(
      (c) => c.id == challengeId,
    );
    bool isActive = challenge.status == 'ongoing';
    bool isCompleted = challenge.status == 'completed';

    return CommonScreen(
      showBannerAd: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Challenge Details".blackTextStyle(
          color: theme.getTextColor,
          fw: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: theme.getTextColor),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              challenge.title.blackTextStyle(
                color: theme.getTextColor,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.extraLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    "Duration: ${challenge.durationDays} Days | XP: +${challenge.rewardXP}"
                        .primaryTextStyle(
                          color: AppColor.orangeColor,
                          fw: FontWeight.bold,
                        ),
              ),
              const SizedBox(height: 16),
              challenge.description.greyTextStyle(
                color: theme.getSecondaryTextColor,
                overflow: TextOverflow.visible,
                fw: FontWeight.normal,
                enumFontSize: EnumFontSize.small,
              ),
              const SizedBox(height: 24),
              "Milestone Timeline".blackTextStyle(
                color: theme.getTextColor,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.large,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: challenge.durationDays,
                  itemBuilder: (context, index) {
                    int dayNum = index + 1;
                    bool isPast =
                        dayNum < challenge.currentDayNumber && isActive;
                    bool isToday =
                        dayNum == challenge.currentDayNumber && isActive;
                    bool isMilestone =
                        dayNum == 7 ||
                        dayNum == 14 ||
                        dayNum == 21 ||
                        dayNum == challenge.durationDays;

                    if (isCompleted) {
                      isPast = true;
                      isToday = false;
                    }

                    Color iconColor = theme.getSecondaryTextColor.withValues(
                      alpha: 0.3,
                    );
                    IconData icon = Icons.circle_outlined;

                    if (isPast) {
                      iconColor = theme.getSuccessColor;
                      icon = Icons.check_circle;
                    } else if (isToday) {
                      iconColor = AppColor.orangeColor;
                      icon = Icons.radio_button_checked;
                    } else if (isMilestone) {
                      iconColor = theme.getPrimaryColor;
                      icon = Icons.card_giftcard;
                    }

                    return Row(
                      children: [
                        Column(
                          children: [
                            Icon(icon, color: iconColor),
                            if (index != challenge.durationDays - 1)
                              Container(
                                height: 30,
                                width: 2,
                                color: isPast
                                    ? theme.getSuccessColor
                                    : theme.getSecondaryTextColor.withValues(
                                        alpha: 0.2,
                                      ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child:
                                "Day $dayNum${isMilestone ? ' - Milestone Reward' : ''}"
                                    .primaryTextStyle(
                                      color: isPast || isToday
                                          ? theme.getTextColor
                                          : theme.getSecondaryTextColor,
                                      fw: isToday || isMilestone
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (challenge.status == 'not_started' ||
                  challenge.status == 'failed')
                SizedBox(
                  width: double.infinity,
                  child: CompButton(
                    title: "Accept Challenge",
                    onPress: () {
                      challengeVM.acceptChallenge(context, challenge.id);
                      CustomToast.showSuccess(
                        context,
                        "Challenge Accepted",
                        "Habits added to your Dashboard. Don't miss a day!",
                      );
                    },
                  ),
                ),
              if (isActive)
                SizedBox(
                  width: double.infinity,
                  child: CompButton(
                    title: "Challenge is Active",
                    isLight: true,
                    onPress: () {
                      CustomToast.showInfo(
                        context,
                        "Ongoing",
                        "Complete the linked tasks in your dashboard!",
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
