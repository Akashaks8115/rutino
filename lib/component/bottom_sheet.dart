import '../libs.dart';

class CompBottomSheet {
  static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
    navigatorKey.currentContext!,
    listen: false,
  );

  static void showFixedBottomDialog({
    required Widget child,
    required RefreshCallback? onRefresh,
    double? height,
  }) {
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            color: themeChangerViewModel.getWhiteColor,
            height: height ?? MediaQuery.of(context).size.height / 1.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MasterSpacer.h.ten(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.close,
                      color: themeChangerViewModel.getBlackColor,
                    ),
                  ),
                ),
                Expanded(child: isRefresh(onRefresh, child)),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showWrapBottomDialog({
    required Widget child,
    bool isBackButtonVisible = true,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Wrap(
                    children: [
                      !isBackButtonVisible
                          ? const SizedBox()
                          : MasterSpacer.h.ten(),
                      !isBackButtonVisible
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: themeChangerViewModel.getWhiteColor,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color:
                                        themeChangerViewModel.getPrimaryColor,
                                  ),
                                ),
                              ),
                            ),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: themeChangerViewModel.getWhiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: child,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showDraggableBottomDialog({
    required Widget Function(BuildContext, ScrollController) builder,
    double initialChildSize = 0.6,
    double minChildSize = 0.4,
    double maxChildSize = 1.0,
  }) {
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: themeChangerViewModel.getWhiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(child: builder(context, scrollController)),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static dynamic isRefresh(onRefresh, child) {
    if (onRefresh != null) {
      return CompRefreshIndicator.show(
        onRefresh: onRefresh,
        child: page(child),
      );
    } else {
      return page(child);
    }
  }

  static SingleChildScrollView page(child) {
    return SingleChildScrollView(
      child: Wrap(
        children: [Padding(padding: const EdgeInsets.all(15.0), child: child)],
      ),
    );
  }
}
