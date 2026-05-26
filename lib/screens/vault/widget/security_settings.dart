import '../../../../libs.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultState = Provider.of<VaultViewModel>(context);
    final themeState = Provider.of<ThemeChangerViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Security & Preferences", themeState),
        _buildTile(
          icon: BootstrapIcons.fingerprint,
          title: "Biometric App Lock",
          subtitle: "Require FaceID/Fingerprint to open app",
          theme: themeState,
          trailing: Switch(
            value: vaultState.isBiometricEnabled,
            activeThumbColor: themeState.getPrimaryColor,
            onChanged: (val) => vaultState.toggleBiometricLock(val, context),
          ),
        ),
        _buildTile(
          icon: BootstrapIcons.moon_stars_fill,
          title: "Dark Mode",
          subtitle: "Toggle application theme",
          theme: themeState,
          trailing: Switch(
            value: themeState.isDarkMode,
            activeThumbColor: themeState.getPrimaryColor,
            onChanged: (val) {
              if (val) {
                themeState.setTheme(ThemeMode.dark);
              } else {
                themeState.setTheme(ThemeMode.light);
              }
            },
          ),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader("Data Vault (Offline)", themeState),
        _buildTile(
          icon: BootstrapIcons.cloud_arrow_up_fill,
          title: "Export Backup",
          subtitle: "Save your entire database as JSON",
          theme: themeState,
          onTap: () => vaultState.exportBackup(context),
        ),
        _buildTile(
          icon: BootstrapIcons.cloud_arrow_down_fill,
          title: "Restore Backup",
          subtitle: "Import your data from a JSON file",
          theme: themeState,
          onTap: () => vaultState.importBackup(context),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeChangerViewModel theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
      child: title.toUpperCase().greyTextStyle(
        color: theme.getSecondaryTextColor,
        enumFontSize: EnumFontSize.small,
        fw: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeChangerViewModel theme,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.getCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: theme.getPrimaryColor),
        title: title.blackTextStyle(
          enumFontSize: EnumFontSize.small,
          color: theme.getTextColor,
          fw: FontWeight.w500,
          overflow: TextOverflow.clip,
        ),
        subtitle: subtitle.greyTextStyle(
          color: theme.getSecondaryTextColor,
          enumFontSize: EnumFontSize.extraSmall,
          overflow: TextOverflow.clip,
          fw: FontWeight.normal,
        ),
        trailing: trailing,
      ),
    );
  }
}
