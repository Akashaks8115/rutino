import '../libs.dart';

extension StringExtension on String {
  Widget primaryTextStyle({
    TextAlign align = TextAlign.left,
    double? height,
    double? letterSpacing,
    Color? color,
    TextOverflow overflow = TextOverflow.ellipsis,
    EnumFontSize enumFontSize = EnumFontSize.medium,
    FontWeight fw = FontWeight.w800,
  }) {
    return Text(
      textAlign: align,
      this,
      style: TextStyle(
        fontSize: MyFontSize.getFontSize(enumFontSize),
        fontWeight: fw,
        overflow: overflow,
        height: height,
        letterSpacing: letterSpacing,
        fontFamily: 'Roboto',
        color:
            color ??
            Provider.of<ThemeChangerViewModel>(
              navigatorKey.currentContext!,
              listen: false,
            ).getPrimaryColor,
      ),
      softWrap: true,
    );
  }

  Widget secondaryTextStyle({
    TextAlign align = TextAlign.left,
    double? height,
    double? letterSpacing,
    Color? color,
    TextOverflow overflow = TextOverflow.ellipsis,
    EnumFontSize enumFontSize = EnumFontSize.medium,
    FontWeight fw = FontWeight.w800,
  }) {
    return Text(
      textAlign: align,
      this,
      style: TextStyle(
        fontSize: MyFontSize.getFontSize(enumFontSize),
        fontWeight: fw,
        overflow: overflow,
        height: height,
        letterSpacing: letterSpacing,
        fontFamily: 'Roboto',
        color:
            color ??
            Provider.of<ThemeChangerViewModel>(
              navigatorKey.currentContext!,
              listen: false,
            ).getSecondaryColor,
      ),
      softWrap: true,
    );
  }

  Widget whiteTextStyle({
    TextAlign align = TextAlign.left,
    double? height,
    double? letterSpacing,
    Color? color,
    TextOverflow overflow = TextOverflow.ellipsis,
    EnumFontSize enumFontSize = EnumFontSize.medium,
    FontWeight fw = FontWeight.w800,
  }) {
    return Text(
      textAlign: align,
      this,
      style: TextStyle(
        fontSize: MyFontSize.getFontSize(enumFontSize),
        fontWeight: fw,
        overflow: overflow,
        height: height,
        letterSpacing: letterSpacing,
        fontFamily: 'Roboto',
        shadows: [
          Shadow(
            offset: const Offset(0.1, 0.5),
            blurRadius: 3.0,
            color: Colors.grey.withValues(alpha: 0.7),
          ),
        ],
        color: color ?? Colors.white,
      ),
      softWrap: true,
    );
  }

  Widget blackTextStyle({
    TextAlign align = TextAlign.left,
    double? height,
    double? letterSpacing,
    Color? color,
    TextOverflow overflow = TextOverflow.ellipsis,
    EnumFontSize enumFontSize = EnumFontSize.medium,
    int? maxLine,
    FontWeight fw = FontWeight.w800,
  }) {
    return Text(
      textAlign: align,
      this,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: MyFontSize.getFontSize(enumFontSize),
        fontWeight: fw,
        fontFamily: 'Roboto',
        height: height,
        letterSpacing: letterSpacing,
        overflow: overflow,
        color:
            color ??
            Provider.of<ThemeChangerViewModel>(
              navigatorKey.currentContext!,
              listen: false,
            ).getBlackColor,
      ),
      softWrap: true,
    );
  }

  Widget greyTextStyle({
    TextAlign align = TextAlign.left,
    double? height,
    double? letterSpacing,
    int? maxLine,
    Color? color,
    TextOverflow overflow = TextOverflow.ellipsis,
    EnumFontSize enumFontSize = EnumFontSize.medium,
    FontWeight fw = FontWeight.w800,
  }) {
    return Text(
      textAlign: align,
      this,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: MyFontSize.getFontSize(enumFontSize),
        fontWeight: fw,
        fontFamily: 'Roboto',
        height: height,
        letterSpacing: letterSpacing,
        overflow: overflow,
        color:
            color ??
            Provider.of<ThemeChangerViewModel>(
              navigatorKey.currentContext!,
              listen: false,
            ).getGreyColor,
      ),
      softWrap: true,
    );
  }

  Widget customTextStyle({
    TextAlign align = TextAlign.left,
    double? height,
    double? letterSpacing,
    double? fontSize,
    Color color = Colors.white,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    FontWeight fw = FontWeight.w800,
  }) {
    return Text(
      textAlign: align,
      this,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize ?? MyFontSize.getFontSize(EnumFontSize.medium),
        fontWeight: fw,
        fontFamily: 'Roboto',
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        overflow: overflow,
      ),
    );
  }

  String isEmptyOrNull({required dynamic returnText}) {
    return (this).isEmpty ? returnText : this;
  }
}
