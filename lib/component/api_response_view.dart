import '../libs.dart';

class ApiResponseView {
  static Padding loading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: CircularProgressIndicator(
          color: Provider.of<ThemeChangerViewModel>(
            navigatorKey.currentContext!,
            listen: false,
          ).getPrimaryColor,
        ),
      ),
    );
  }

  static Padding customLoading({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(child: child),
    );
  }

  static Widget staticNoReviewFound({required String message}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/image/noReviewfound.png", scale: 4),
        message.primaryTextStyle(enumFontSize: EnumFontSize.large),
      ],
    );
  }

  static Widget staticNoHistoryFound({required String message}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/image/noHistoryFound.png", scale: 4),
        MasterSpacer.h.ten(),
        MasterSpacer.h.ten(),
        MasterSpacer.h.ten(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: message.primaryTextStyle(
            enumFontSize: EnumFontSize.medium,
            overflow: TextOverflow.clip,
            align: TextAlign.center,
          ),
        ),
      ],
    );
  }

  static Widget serverError({required String msg, VoidCallback? onRetry}) {
    mDebugPrintError(msg.toString());
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Colors.red,
                size: 60,
              ),
            ),
            MasterSpacer.h.thirty(),
            msg.blackTextStyle(
              overflow: TextOverflow.clip,
              align: TextAlign.center,
              enumFontSize: EnumFontSize.medium,
              fw: FontWeight.w600,
            ),
            if (onRetry != null) ...[
              MasterSpacer.h.thirty(),
              CompButton(title: "Try Again", onPress: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
