import '../../../../libs.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);

    return CommonScreen(
      showBannerAd: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CompAppBar.titleBar(
          title: "Profile",
          isBackButtonVisible: false,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.getPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.getPrimaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    BootstrapIcons.info_circle_fill,
                    color: theme.getPrimaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        "Privacy Note: This app does not use any online APIs or databases. All your data is stored locally on your device. If you uninstall the app, all your data will be permanently cleared."
                            .blackTextStyle(
                              color: theme.getTextColor,
                              height: 1.4,
                              enumFontSize: EnumFontSize.small,
                              maxLine: 10,
                            ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            "MILESTONES".greyTextStyle(
              color: theme.getSecondaryTextColor,
              enumFontSize: EnumFontSize.small,
              fw: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            const SizedBox(height: 16),
            const BadgesGrid(),
            const SizedBox(height: 32),
            "ACTIVE CHALLENGES".greyTextStyle(
              color: theme.getSecondaryTextColor,
              enumFontSize: EnumFontSize.small,
              fw: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            const SizedBox(height: 16),
            const ActiveChallengesGrid(),
            const SizedBox(height: 32),
            const SecuritySettings(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
