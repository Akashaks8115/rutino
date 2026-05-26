import '../../../../libs.dart';

class BadgesGrid extends StatelessWidget {
  const BadgesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VaultViewModel>(context);
    final theme = Provider.of<ThemeChangerViewModel>(context);

    final badges = [
      {"icon": "🔥", "title": "7-Day Streak", "unlocked": state.xp >= 50},
      {"icon": "🧘", "title": "Zen Master", "unlocked": state.xp >= 200},
      {"icon": "🏆", "title": "Consistency", "unlocked": state.xp >= 1000},
      {
        "icon": "🛡️",
        "title": "Vault Guard",
        "unlocked": state.isBiometricEnabled,
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final badge = badges[index];
          final bool isUnlocked = badge['unlocked'] as bool;

          return Opacity(
            opacity: isUnlocked ? 1.0 : 0.4,
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.getCardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUnlocked
                      ? theme.getPrimaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (badge['icon'] as String).customTextStyle(fontSize: 32),
                  const SizedBox(height: 8),
                  (badge['title'] as String).blackTextStyle(
                    align: TextAlign.center,
                    color: theme.getTextColor,
                    enumFontSize: EnumFontSize.extraSmall,
                    fw: FontWeight.w500,
                    // maxLines: 2,
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
