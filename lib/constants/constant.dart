class Constants {
  static String appName = "Rutino";
  static String appVersion = "";
  static String packageName = "";
  static String appSite = "https://google.com";
  static String appIcon = "assets/icons/logo.png";
  static String appIconUrl =
      "https://imagedelivery.net/Ud25niyQxx-TAH-Uqr9bjQ/7fa9bcaa-16e6-416f-5b03-789bccf13800/original";

  static bool isDebug = false;
  static double defaultRadius = 10; //25
  static double defaultPadding = 10; //25

  static String getDebugString({required String error}) {
    if (isDebug) {
      return error;
    } else {
      return defaultError;
    }
  }

  static String lorem =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ";
  static String refresh = "Refresh";
  static String rupee = "₹";
  static String appPlayStoreUrl = "";
  static int maxDateTime = 2101;
  static String defaultError = "Something went wrong";

  static String splash = "";
  static String defaultString = "----";
  static String defaultCurrency = "RS ";
  static String defaultUserNameString = "Anonymous-User";
  static String device = "Mobile";
  static double defaultDouble = 0;
  static DateTime defaultDate = DateTime(0);
  static double defaultBannerHeight = 150;
  static double defaultPagePaddingHorizontally = 15;
  static String defaultTermAndConditions = '''
  ''';
}
