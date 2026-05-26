class AppUrl {
  static const bool isDebug = true; // For Test
  // static const bool isDebug = false; // For Production

  // true for Development , false for Production

  static var devUrl = "https://dev.mczenapi.ethermarketing.cloud/api/v1/";
  static var devUrl1 = "https://dev.mczen.ethermarketing.cloud";
  static var proUrl = "https://api.mczen.in/api/v1/";
  static var proUrl1 = "https://mczen.in";

  static String get baseUrl => isDebug ? devUrl : proUrl;
  static String get baseUrl1 => isDebug ? devUrl1 : proUrl1;
  static String get getImageUrl => "${baseUrl}api/image/upload";

  // User
  static String get sendOtp => "${baseUrl}auth/sendOtp";
  static String get verifyOtp => "${baseUrl}auth/loginVerifyOtp";
  static String get usernamePasswordLogin => "${baseUrl}auth/userLogin";
  static String get validateRegister => "${baseUrl}auth/validateRegister";
  static String get userInsert => "${baseUrl}user/insert";
  static String get userDataDeleteUrl => "${baseUrl}user/userDataDelete";
  static String get getSettingKey => "${baseUrl}setting/get";

  // Home
  static String get homeUrl => "${baseUrl}api/customer/getUserDashboard";
  static String get getUpsertCartUrl => "${baseUrl}api/product/getUpsertCart";
  static String get flashDealsUrl => "${baseUrl}api/coupons/flashDeals";
  static String get manageCustomerAddressUrl =>
      "${baseUrl}api/customer/manageCustomerAddress";
  static String get createCustomerOrderUrl =>
      "${baseUrl}api/order/createCustomerOrder";

  // Dashboard
  static String get getFirstPageUrl => "${baseUrl}dashboard/getFirstPage";
  static String get enquiryInsertUrl => "${baseUrl}franchise/enquiryInsert";

  // Products
  static String get getProductListUrl => "${baseUrl}api/product/getProducts";
  static String get getCategoryUrl => "${baseUrl}category/get";
  static String get getProductsUrl => "${baseUrl}product/get";
  static String get getProductsDetailsUrl => "${baseUrl}product/detail/get";

  // WishList
  static String get getWishlistUrl => "${baseUrl}wishlist/get";
  static String get insertWishlistUrl => "${baseUrl}wishlist/insert";
  static String get updateWishlistUrl => "${baseUrl}wishlist/update";

  // Cart
  static String get getCartUrl => "${baseUrl}cart/get";
  static String get cartActionUrl => "${baseUrl}cart/cartAction";

  // Address
  static String get getAddressUrl => "${baseUrl}address/get";
  static String get insertAddressUrl => "${baseUrl}address/insert";
  static String get updateAddressUrl => "${baseUrl}address/update";

  // Profile
  static String get getProfileUrl => "${baseUrl}user/profile";
  static String get photoUpdateUrl => "${baseUrl}user/photoUpdate";
  static String get updateUrl => "${baseUrl}user/update";
  static String get changePasswordUrl => "${baseUrl}user/passwordUpdate";
  static String get familyActionUrl => "${baseUrl}user/familyAction";

  // Upload File
  static String get uploadImageUrl => "${baseUrl}file/uploadImage";

  // Order
  static String get orderSummaryUrl => "${baseUrl}order/summary";
  static String get orderValidateUrl => "${baseUrl}order/validate";
  static String get orderCheckStatusUrl => "${baseUrl}payment/orderCheckStatus";
  static String get orderGetUrl => "${baseUrl}order/get";

  // BackOffice
  static String get backofficeDashboardUrl => "${baseUrl}backoffice/Dashboard";
  static String get userRankListUrl => "${baseUrl}backoffice/userRankList";
  static String get userGetDirectUrl => "${baseUrl}backoffice/userGetDirect";
  static String get userGetTeamUrl => "${baseUrl}backoffice/userGetTeam";
  static String get teamGetTreeUrl => "${baseUrl}backoffice/teamGetTree";

  // Withdrawal
  static String get requestValidateUrl =>
      "${baseUrl}withdrawal/requestValidate";
  static String get insertRequestUrl => "${baseUrl}withdrawal/insertRequest";
  static String get withdrawalGetUrl => "${baseUrl}withdrawal/withdrawalGet";
  static String get userWalletHistoryGetUrl =>
      "${baseUrl}wallet/UserWalletHistoryGet";
  static String get bankingGetUrl => "${baseUrl}withdrawal/bankingGet";
  static String get getIfscDetailsUrl => "${baseUrl}withdrawal/getIfscDetails";
  static String get bankingInsertUrl => "${baseUrl}withdrawal/bankingAction";

  // Wallet
  static String get transferToPPWalletUrl =>
      "${baseUrl}wallet/transferToPPWallet";
  static String get transferToShoppingUrl =>
      "${baseUrl}wallet/transferToShopping";
  static String get transferCTOToShoppingUrl =>
      "${baseUrl}wallet/transferCTOToShopping";
  static String get getCouponUrl => "${baseUrl}coupon/get";

  // Notification
  static String get newsGetUrl => "${baseUrl}notification/newsGet";
  static String get notificationGetUrl =>
      "${baseUrl}notification/notificationGet";
  static String get userDeviceUpsertUrl => "${baseUrl}outer/userDeviceUpsert";

  // Business Summary
  static String get masterDailyClosingUrl =>
      "${baseUrl}outer/masterDailyClosing";
  static String get bonusGetUrl => "${baseUrl}backoffice/bonusGet";
  static String get businessSummaryUrl =>
      "${baseUrl}backoffice/businessSummary";
  static String get getRankSummaryUrl => "${baseUrl}common/getRankSummary";
  static String get getGMCMemberUrl => "${baseUrl}common/getGMCMember";
  static String get gmcClaimUrl => "${baseUrl}backOffice/GMC/gmcClaim";
  static String get gmcIDDetailsGetUrl => "${baseUrl}common/gmcIDDetailsGet";
  static String get getGlobalBonusUrl => "${baseUrl}common/getGlobalBonus";
  static String get getPromotionUrl => "${baseUrl}common/getPromotion";

  // Kyc
  static String get kycGetUrl => "${baseUrl}backoffice/kycGet";
  static String get kycInsertUrl => "${baseUrl}backoffice/kycAction";

  // card
  static String get userCardGetUrl => "${baseUrl}backoffice/userCardGet";
  static String get userCardGenerateUrl =>
      "${baseUrl}backoffice/userCardGenerate";

  // CTO
  static String get ctoDashboardUrl => "${baseUrl}backoffice/ctoDashboard";
  static String get ctoReportUrl => "${baseUrl}backoffice/ctoReport";
  static String get ctoWalletDetailsUrl =>
      "${baseUrl}backoffice/ctoWalletDetails";
  static String get userCTOBonusDetailsUrl =>
      "${baseUrl}common/UserCTOBonusDetails";

  // Kyc
  static String get adharOtpRequestUrl => "${baseUrl}kyc/aadhaar/otp/request";
  static String get adharOtpVerifyUrl => "${baseUrl}kyc/aadhaar/otp/verify";
  static String get panVerifyUrl => "${baseUrl}kyc/pan/verify";
  static String get insertKycUrl => "${baseUrl}kyc/insertKyc";
}

class ImageUrl {
  static var imageBaseUrl = "https://imagedelivery.net/Ud25niyQxx-TAH-Uqr9bjQ/";

  static String imageThumb({required photoUrl}) {
    var url = "$imageBaseUrl$photoUrl/thumb";
    return url;
  }

  static String imageOriginal({required photoUrl}) {
    var url = "$imageBaseUrl$photoUrl/original";
    return url;
  }

  static String imageL({required photoUrl}) {
    var url = "$imageBaseUrl$photoUrl/l";
    return url;
  }

  static String imageM({required photoUrl}) {
    var url = "$imageBaseUrl$photoUrl/m";
    return url;
  }
}
