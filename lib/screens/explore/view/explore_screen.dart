import '../../../../libs.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final dashboardVM = Provider.of<DashboardViewModel>(context);

    return CommonScreen(
      showBannerAd: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),

        child: CompAppBar.titleBar(
          title: "Explore",
          isBackButtonVisible: false,
        ),
      ),
      child: ListView(
        children: [
          MasterSpacer.h.ten(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.challengeRoom);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.orangeColor, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.orangeColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, size: 40, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Challenge Room".blackTextStyle(
                          color: Colors.white,
                          fw: FontWeight.bold,
                        ),
                        "Accept extreme challenges and earn massive XP. Don't miss a day!"
                            .primaryTextStyle(
                              color: Colors.white70,
                              overflow: TextOverflow.clip,
                              fw: FontWeight.w500,
                              enumFontSize: EnumFontSize.extraSmall,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          "Tools & Trackers".blackTextStyle(
            color: theme.getTextColor,
            fw: FontWeight.bold,
            enumFontSize: EnumFontSize.large,
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildGridItem(
                context: context,
                theme: theme,
                title: "Drink Water",
                icon: "💧",
                infoText:
                    "Stay hydrated by tracking your daily water intake. Helps maintain energy and health.",
                isEnabled: dashboardVM.enabledFeatures.contains('1'),
                onToggle: (val) {
                  dashboardVM.toggleFeature(
                    '1',
                    val,
                    HabitModel(
                      id: '1',
                      title: 'Drink Water',
                      completedCount: 0,
                      targetCount: 3500,
                      timeOfDay: 'Morning',
                      icon: '💧',
                      type: HabitType.quantifiable,
                    ),
                  );
                },
                onTap: () {
                  if (dashboardVM.enabledFeatures.contains('1')) {
                    Navigator.pushNamed(context, RoutesName.waterIntake);
                  }
                },
              ),
              _buildGridItem(
                context: context,
                theme: theme,
                title: "Meditation",
                icon: "🧘",
                infoText:
                    "Relax your mind, reduce stress, and improve focus with customizable guided meditation sessions.",
                isEnabled: dashboardVM.enabledFeatures.contains('2'),
                onToggle: (val) {
                  dashboardVM.toggleFeature(
                    '2',
                    val,
                    HabitModel(
                      id: '2',
                      title: 'Meditation',
                      completedCount: 0,
                      targetCount: 1,
                      timeOfDay: 'Morning',
                      icon: '🧘',
                      type: HabitType.yesNo,
                    ),
                  );
                },
                onTap: () {
                  if (dashboardVM.enabledFeatures.contains('2')) {
                    Navigator.pushNamed(context, RoutesName.meditation);
                  }
                },
              ),
              _buildGridItem(
                context: context,
                theme: theme,
                title: "Read Book",
                icon: "📚",
                infoText:
                    "Build a reading habit by tracking chapters, pages, and daily reading time.",
                isEnabled: dashboardVM.enabledFeatures.contains('3'),
                onToggle: (val) {
                  dashboardVM.toggleFeature(
                    '3',
                    val,
                    HabitModel(
                      id: '3',
                      title: 'Read Book',
                      completedCount: 0,
                      targetCount: 30,
                      timeOfDay: 'Afternoon',
                      icon: '📚',
                      type: HabitType.quantifiable,
                    ),
                  );
                },
                onTap: () {
                  if (dashboardVM.enabledFeatures.contains('3')) {
                    Navigator.pushNamed(context, RoutesName.bookReading);
                  }
                },
              ),
              _buildGridItem(
                context: context,
                theme: theme,
                title: "Workout",
                icon: "🏋️",
                infoText:
                    "Log your daily exercises, track different muscle groups, and stay physically active.",
                isEnabled: dashboardVM.enabledFeatures.contains('4'),
                onToggle: (val) {
                  dashboardVM.toggleFeature(
                    '4',
                    val,
                    HabitModel(
                      id: '4',
                      title: 'Workout',
                      completedCount: 0,
                      targetCount: 1,
                      timeOfDay: 'Evening',
                      icon: '🏋️',
                      type: HabitType.yesNo,
                    ),
                  );
                },
                onTap: () {
                  if (dashboardVM.enabledFeatures.contains('4')) {
                    Navigator.pushNamed(context, RoutesName.workoutSetup);
                  }
                },
              ),
              _buildGridItem(
                context: context,
                theme: theme,
                title: "Sleep Tracker",
                icon: "💤",
                infoText:
                    "Monitor your sleep cycle, establish healthy sleep routines, and wake up refreshed.",
                isEnabled: dashboardVM.enabledFeatures.contains('5'),
                onToggle: (val) {
                  dashboardVM.toggleFeature(
                    '5',
                    val,
                    HabitModel(
                      id: '5',
                      title: 'Sleep Tracker',
                      completedCount: 0,
                      targetCount: 1,
                      timeOfDay: 'Morning',
                      icon: '💤',
                      type: HabitType.yesNo,
                    ),
                  );
                },
                onTap: () {
                  if (dashboardVM.enabledFeatures.contains('5')) {
                    Navigator.pushNamed(context, RoutesName.sleepTracker);
                  }
                },
              ),
              _buildGridItem(
                context: context,
                theme: theme,
                title: "Journal",
                icon: "📝",
                infoText:
                    "Write down your daily thoughts, practice gratitude, and track your mood.",
                isComingSoon: true,
                onTap: () {},
              ),
              _buildGridItem(
                context: context,
                theme: theme,
                title: "Step Counter",
                icon: "👟",
                infoText:
                    "Count your daily steps passively and set goals for active movement.",
                isComingSoon: true,
                onTap: () {},
              ),
            ],
          ),
          // Close ListView children
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required BuildContext context,
    required ThemeChangerViewModel theme,
    required String title,
    required String icon,
    String? infoText,
    bool isComingSoon = false,
    bool isEnabled = false,
    ValueChanged<bool>? onToggle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEnabled
              ? theme.getPrimaryColor.withValues(alpha: 0.1)
              : theme.getCardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isEnabled
                ? theme.getPrimaryColor.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 1.5,
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? theme.getPrimaryColor.withValues(alpha: 0.2)
                        : theme.getScaffoldColor,
                    shape: BoxShape.circle,
                  ),
                  child: icon.customTextStyle(fontSize: 32),
                ),
                if (isComingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.getScaffoldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: "SOON".greyTextStyle(
                      color: theme.getSecondaryTextColor,
                      fw: FontWeight.bold,
                      enumFontSize: EnumFontSize.small,
                    ),
                  )
                else
                  SizedBox(
                    height: 24,
                    child: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isEnabled,
                        onChanged: onToggle,
                        activeColor: Colors.white,
                        activeTrackColor: theme.getPrimaryColor,
                        inactiveThumbColor: theme.getSecondaryTextColor,
                        inactiveTrackColor: theme.getScaffoldColor,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: title.blackTextStyle(
                    color: isComingSoon
                        ? theme.getSecondaryTextColor
                        : theme.getTextColor,
                    fw: FontWeight.bold,
                    enumFontSize: EnumFontSize.medium,
                  ),
                ),
                if (infoText != null)
                  GestureDetector(
                    onTap: () =>
                        _showInfoDialog(context, title, infoText, theme),
                    child: Icon(
                      Icons.info_outline,
                      color: theme.getSecondaryTextColor,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(
    BuildContext context,
    String title,
    String infoText,
    ThemeChangerViewModel theme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.getCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: theme.getPrimaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: title.blackTextStyle(
                color: theme.getTextColor,
                fw: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: infoText.greyTextStyle(
          overflow: TextOverflow.clip,
          color: theme.getSecondaryTextColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: "Got it".blackTextStyle(
              color: theme.getPrimaryColor,
              fw: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
