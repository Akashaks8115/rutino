
import '../../../../libs.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VaultViewModel>(context);
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final String userName = Hive.box('prefs').get('user_name', defaultValue: 'User');
    final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.getPrimaryColor.withValues(alpha: 0.15),
            theme.getCardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.getPrimaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.getPrimaryColor.withValues(alpha: 0.05),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.getPrimaryColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.getPrimaryColor.withValues(alpha: 0.2),
                  child: initial.primaryTextStyle(
                    color: theme.getPrimaryColor,
                    enumFontSize: EnumFontSize.extraLarge,
                    fw: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Level ${state.level}".blackTextStyle(
                      color: theme.getTextColor,
                      fw: FontWeight.bold,
                      enumFontSize: EnumFontSize.large,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    "${state.xp} XP / ${state.level * 500} XP".greyTextStyle(
                      color: theme.getSecondaryTextColor,
                      enumFontSize: EnumFontSize.small,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: state.levelProgress,
              minHeight: 10,
              backgroundColor: theme.getPrimaryColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.getPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
