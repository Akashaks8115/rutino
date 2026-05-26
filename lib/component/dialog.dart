
import '../libs.dart';

class CompDialog {
  static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
    navigatorKey.currentContext!,
    listen: false,
  );

  static Future showReCheck({
    String title = 'Please re-check information',
    required String msg,
    required Function onConfirm,
  }) {
    return showGeneralDialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              backgroundColor: themeChangerViewModel.getWhiteColor,
              shape: OutlineInputBorder(
                borderSide: BorderSide(
                  color: themeChangerViewModel.getPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              title: Column(
                children: [
                  title.blackTextStyle(enumFontSize: EnumFontSize.medium),
                  MasterSpacer.h.five(),
                  MasterSpacer.h.five(),
                  msg.blackTextStyle(
                    overflow: TextOverflow.clip,
                    align: TextAlign.center,
                    fw: FontWeight.normal,
                    enumFontSize: EnumFontSize.small,
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: CompButton(
                        title: "Cancel",

                        onPress: () {
                          Navigator.pop(context);
                        },
                      ),
                      // CompButton(
                      //   isLight: true,
                      //   title: "Cancel",
                      //   removePaddings: true,
                      //   onPress: () {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                    ),
                    MasterSpacer.w.ten(),
                    MasterSpacer.w.ten(),
                    Expanded(
                      child: CompButton(
                        onPress: () {
                          onConfirm();
                        },
                        title: "Confirm",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: navigatorKey.currentContext!,
      pageBuilder: (context, animation1, animation2) {
        return const Center();
      },
    );
  }

  static void errorDialogBox({
    required String message,
    required String heading,
  }) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Constants.defaultRadius,
            ), // <<< radius reduce
          ),
          icon: CircleAvatar(
            backgroundColor: themeChangerViewModel.getErrorColor,
            radius: 50,
            child: Icon(
              size: 50,
              Icons.close,
              color: themeChangerViewModel.getWhiteColor,
            ),
          ),
          backgroundColor: themeChangerViewModel.getWhiteColor,
          title: heading.blackTextStyle(
            align: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
          content: message.greyTextStyle(
            align: TextAlign.center,
            fw: FontWeight.normal,
            overflow: TextOverflow.clip,
          ),
          actions: [
            CompButton(
              onPress: () {
                Navigator.pop(context);
              },
              title: "Ok",
            ),
          ],
        );
      },
    );
  }

  static void successDialogBox({
    required String message,
    required String heading,
    int duration = 5,
    bool showCopyButton = false,
    String? copyText,
  }) {
    bool dialogManuallyClosed = false;
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: themeChangerViewModel.getWhiteColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeChangerViewModel.getPrimaryColor.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: themeChangerViewModel.getPrimaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeChangerViewModel.getPrimaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: themeChangerViewModel.getWhiteColor,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: heading.blackTextStyle(
                    align: TextAlign.center,
                    enumFontSize: EnumFontSize.large,
                    fw: FontWeight.bold,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeChangerViewModel.getGreyColor.withValues(
                        alpha: 0.05,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: themeChangerViewModel.getGreyColor.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        message.greyTextStyle(
                          align: TextAlign.center,
                          fw: FontWeight.normal,
                          enumFontSize: EnumFontSize.small,
                          overflow: TextOverflow.clip,
                        ),
                        if (showCopyButton) ...[
                          MasterSpacer.h.ten(),
                          MasterSpacer.h.five(),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: copyText ?? message),
                              );
                              CompDialog.successToast(
                                context: context,
                                msg: "Credentials copied to clipboard!",
                                title: "Copied",
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: themeChangerViewModel.getPrimaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.copy_rounded,
                                    size: 16,
                                    color:
                                        themeChangerViewModel.getPrimaryColor,
                                  ),
                                  MasterSpacer.w.ten(),
                                  "Copy Credentials".primaryTextStyle(
                                    enumFontSize: EnumFontSize.extraSmall,
                                    fw: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: CompButton(
                    onPress: () {
                      dialogManuallyClosed = true;
                      Navigator.pop(context);
                    },
                    title: "Continue",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      dialogManuallyClosed = true;
    });

    Future.delayed(Duration(seconds: duration), () {
      if (!dialogManuallyClosed &&
          Navigator.of(navigatorKey.currentContext!).canPop()) {
        Navigator.of(navigatorKey.currentContext!).pop();
      }
    });
  }

  static void showToast({
    String msg = 'Something went wrong',
    required BuildContext context,
    int autoCloseDuration = 3,
  }) {
    CustomToast.showInfo(context, "Notification", msg);
  }

  static void successToast({
    String title = "Success",
    required String msg,
    required BuildContext context,
    int autoCloseDuration = 3,
  }) {
    CustomToast.showSuccess(context, title, msg);
  }

  static void errorToast({
    String title = "Error",
    required String msg,
    required BuildContext context,
    int autoCloseDuration = 3,
  }) {
    CustomToast.showWarning(context, title, msg);
  }

  static void warningToast({
    String title = "Warning",
    required String msg,
    required BuildContext context,
    int autoCloseDuration = 3,
  }) {
    CustomToast.showWarning(context, title, msg);
  }

  static void bottomSheetConfirmation({
    required Function afterConfirm,
    required String content,
    String okString = "Accept",
    required String heading,
  }) {
    if (content.isEmpty) {
      afterConfirm();
    } else {
      CompBottomSheet.showWrapBottomDialog(
        child: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MasterSpacer.h.ten(),
              MasterSpacer.h.ten(),
              heading.blackTextStyle(),
              MasterSpacer.h.ten(),
              content.greyTextStyle(
                enumFontSize: EnumFontSize.extraSmall,
                overflow: TextOverflow.clip,
                fw: FontWeight.normal,
              ),
              MasterSpacer.h.ten(),
              MasterSpacer.h.ten(),
              MasterSpacer.h.ten(),
              Row(
                children: [
                  Expanded(
                    child: CompButton(
                      isLight: true,
                      onPress: () {
                        Navigator.pop(navigatorKey.currentContext!);
                      },
                      title: "Cancel",
                    ),
                  ),
                  MasterSpacer.w.ten(),
                  Expanded(
                    child: CompButton(
                      onPress: () {
                        Navigator.pop(navigatorKey.currentContext!);
                        afterConfirm();
                      },
                      title: okString,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  static void showPendingDialog({
    required String message,
    required VoidCallback onRetry,
    required VoidCallback onCancel,
  }) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: themeChangerViewModel.getWhiteColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeChangerViewModel.getPendingColor.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: themeChangerViewModel.getPendingColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeChangerViewModel.getPendingColor
                                .withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.hourglass_empty_rounded,
                        color: themeChangerViewModel.getWhiteColor,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: "Payment Pending".blackTextStyle(
                    align: TextAlign.center,
                    enumFontSize: EnumFontSize.large,
                    fw: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: message.greyTextStyle(
                    align: TextAlign.center,
                    fw: FontWeight.normal,
                    enumFontSize: EnumFontSize.small,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: CompButton(
                          isLight: true,
                          onPress: onCancel,
                          title: "Cancel",
                        ),
                      ),
                      MasterSpacer.w.twelve(),
                      Expanded(
                        child: CompButton(onPress: onRetry, title: "Retry"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
