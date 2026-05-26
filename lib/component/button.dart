import '../libs.dart';

class CompButton extends StatefulWidget {
  final String title;
  final bool loading;
  final bool disable;
  final VoidCallback onPress;
  final bool removePaddings;
  final bool isLight;

  const CompButton({
    super.key,
    required this.title,
    this.loading = false,
    this.disable = false,
    required this.onPress,
    this.removePaddings = false,
    this.isLight = false,
  });

  @override
  State<CompButton> createState() => _CompButtonState();
}

class _CompButtonState extends State<CompButton> {
  late ThemeChangerViewModel themeChangerViewModel;

  @override
  void initState() {
    super.initState();
    themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
      navigatorKey.currentContext!,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.disable || widget.loading;

    return InkWell(
      onTap: isDisabled ? null : widget.onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: widget.removePaddings ? 35 : 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: widget.disable
                  ? LinearGradient(colors: [AppColor.grey, AppColor.grey])
                  : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        widget.isLight
                            ? themeChangerViewModel.getWhiteColor
                            : themeChangerViewModel.getPrimaryColor,
                        widget.isLight
                            ? themeChangerViewModel.getWhiteColor
                            : themeChangerViewModel.getPrimaryColor,
                      ],
                    ),
              border: Border.all(
                color: widget.isLight
                    ? themeChangerViewModel.getPrimaryColor
                    : Colors.white,
              ),
            ),

            // ---------------- LOADING STATE ----------------
            child: widget.loading
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: widget.removePaddings ? 11 : 18,
                          height: widget.removePaddings ? 11 : 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: widget.isLight
                                ? themeChangerViewModel.getPrimaryColor
                                : themeChangerViewModel.getWhiteColor,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // LOADING TEXT
                        Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: widget.removePaddings ? 12 : 15,
                            color: widget.isLight
                                ? themeChangerViewModel.getPrimaryColor
                                : themeChangerViewModel.getWhiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                // ---------------- NORMAL TEXT ----------------
                : Center(
                    child: widget.isLight
                        ? widget.title.primaryTextStyle(
                            enumFontSize: widget.removePaddings
                                ? EnumFontSize.small
                                : EnumFontSize.medium,
                          )
                        : widget.title.whiteTextStyle(
                            enumFontSize: widget.removePaddings
                                ? EnumFontSize.small
                                : EnumFontSize.medium,
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
