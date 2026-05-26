import '../libs.dart';

class CompAppBar {
  static AppBar titleBar({
    bool isBackButtonVisible = true,
    String title = "Test",
    String? subtitle,
    Widget? titleWidget,
    List<Widget>? actions,
    Function()? onPressed,
  }) {
    final themeVM = Provider.of<ThemeChangerViewModel>(
      navigatorKey.currentContext!,
      listen: false,
    );

    Widget finalTitle =
        titleWidget ??
        (subtitle != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  title.customTextStyle(
                    fontSize: 18,
                    fw: FontWeight.w800,
                    color: themeVM.getTextColor,
                  ),
                  const SizedBox(height: 2),
                  subtitle.customTextStyle(
                    color: themeVM.isDarkMode
                        ? Colors.white70
                        : const Color(0xFF475569),
                    fontSize: 10,
                    fw: FontWeight.w400,
                    maxLines: 2,
                    align: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : title.customTextStyle(
                fontSize: 18,
                fw: FontWeight.w800,
                color: themeVM.getTextColor,
              ));

    return AppBar(
      surfaceTintColor: themeVM.getWhiteColor,
      actions: actions,
      backgroundColor: themeVM.getWhiteColor,
      scrolledUnderElevation: 0.5,
      shadowColor: themeVM.getBlackColor.withValues(alpha: 0.1),
      leading: isBackButtonVisible
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeVM.getGreyColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: themeVM.getGreyColor,
                  size: 16,
                ),
              ),
              onPressed:
                  onPressed ??
                  () {
                    Navigator.of(navigatorKey.currentContext!).pop();
                  },
            )
          : null,
      elevation: 0,
      centerTitle: true,
      title: finalTitle,
      shape: Border(
        bottom: BorderSide(
          color: themeVM.getGreyColor.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
    );
  }

  static Row eachOption({required Function onTap, required IconData icon}) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
        ),
        MasterSpacer.w.ten(),
      ],
    );
  }

  static AppBar backOfficeAppBar({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String title,
    List<Widget>? actions,
  }) {
    final themeVM = Provider.of<ThemeChangerViewModel>(
      navigatorKey.currentContext!,
      listen: false,
    );
    return AppBar(
      backgroundColor: themeVM.getWhiteColor,
      surfaceTintColor: themeVM.getWhiteColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeVM.getGreyColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.menu_rounded,
            color: themeVM.getGreyColor,
            size: 20,
          ),
        ),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      title: title.customTextStyle(
        fontSize: 18,
        fw: FontWeight.w800,
        color: themeVM.getTextColor,
      ),
      centerTitle: true,
      actions: actions,
      shape: Border(
        bottom: BorderSide(
          color: themeVM.getGreyColor.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
    );
  }
}
