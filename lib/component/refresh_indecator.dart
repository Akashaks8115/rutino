import '../libs.dart';

class CompRefreshIndicator {
  static RefreshIndicator show({
    required Widget child,
    required RefreshCallback onRefresh,
  }) {
    return RefreshIndicator(
      backgroundColor: AppColor.whiteColor,
      color: Provider.of<ThemeChangerViewModel>(
        navigatorKey.currentContext!,
        listen: false,
      ).getPrimaryColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
