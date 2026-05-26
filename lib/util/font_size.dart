class MyFontSize {
  static double getFontSize(EnumFontSize enumFontSize) {
    double fs = 16;
    if (enumFontSize == EnumFontSize.larger) {
      fs = 40;
    } else if (enumFontSize == EnumFontSize.extraLarge) {
      fs = 25;
    } else if (enumFontSize == EnumFontSize.large) {
      fs = 18;
    } else if (enumFontSize == EnumFontSize.medium) {
      fs = 16;
    } else if (enumFontSize == EnumFontSize.small) {
      fs = 14;
    } else if (enumFontSize == EnumFontSize.extraSmall) {
      fs = 12;
    } else {
      fs = 14;
    }
    return fs;
  }
}

enum EnumFontSize {
  larger, //20
  extraLarge, //20
  large, //18
  medium, //16
  small, //14
  extraSmall, //12
}
