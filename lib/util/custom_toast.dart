import 'package:toastification/toastification.dart';

import '../libs.dart';

class CustomToast {
  static void showSuccess(BuildContext context, String title, String message) {
    final theme = Provider.of<ThemeChangerViewModel>(context, listen: false);
    _showToast(
      context: context,
      theme: theme,
      type: ToastificationType.success,
      title: title,
      message: message,
      primaryColor: theme.getSuccessColor,
      icon: Icons.check_circle_rounded,
    );
  }

  static void showInfo(BuildContext context, String title, String message) {
    final theme = Provider.of<ThemeChangerViewModel>(context, listen: false);
    _showToast(
      context: context,
      theme: theme,
      type: ToastificationType.info,
      title: title,
      message: message,
      primaryColor: theme.getPrimaryColor,
      icon: Icons.info_rounded,
    );
  }

  static void showWarning(BuildContext context, String title, String message) {
    final theme = Provider.of<ThemeChangerViewModel>(context, listen: false);
    _showToast(
      context: context,
      theme: theme,
      type: ToastificationType.warning,
      title: title,
      message: message,
      primaryColor: theme.getWarningColor,
      icon: Icons.warning_rounded,
    );
  }

  static void _showToast({
    required BuildContext context,
    required ThemeChangerViewModel theme,
    required ToastificationType type,
    required String title,
    required String message,
    required Color primaryColor,
    required IconData icon,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      title: title.blackTextStyle(
        color: theme.getTextColor,
        fw: FontWeight.bold,
        enumFontSize: EnumFontSize.small,
      ),
      description: message.greyTextStyle(
        color: theme.getSecondaryTextColor,
        enumFontSize: EnumFontSize.extraSmall,
        overflow: TextOverflow.clip,
      ),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: theme.getCardColor.withValues(alpha: 0.85),
      applyBlurEffect: true,
      primaryColor: primaryColor,
      icon: Icon(icon, color: primaryColor),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        linearTrackColor: theme.getScaffoldColor,
        color: primaryColor,
      ),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}
