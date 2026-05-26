// import 'dart:convert';
//
// import 'package:event_booking_userside/model/AppSettingModel.dart';
// import 'package:http/http.dart';
// import 'package:package_info_plus/package_info_plus.dart';
//
// import '../../../libs.dart';
// import '../../playstore_update_checker/update_cheker_libs.dart';
//
// class HelperFunctions {
//   static Widget wrapWithAnimatedBuilder({
//     required Animation<Offset> animation,
//     required Widget child,
//   }) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (_, __) => FractionalTranslation(
//         translation: animation.value,
//         child: child,
//       ),
//     );
//   }
//
//   static String getMBFromBytes(String? byte) {
//     if (byte != null) {
//       double byteData = double.parse(byte);
//       double mbData = byteData / 1000000;
//       return getRoundUpTo(mbData.toString(), upto: 0);
//     } else {
//       return '';
//     }
//   }
//
//   static String getRoundUpTo(String number, {int upto = 6}) {
//     if (number == 'null' || number.isEmpty) {
//       return "0";
//     } else {
//       double numb = double.parse(number);
//
//       String n = numb.toStringAsFixed(upto);
//       double val = double.parse(n);
//       RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
//       String s = val.toString().replaceAll(regex, '');
//
//       return numb < 0 ? "0" : s;
//     }
//   }
//
//   static jump(
//       {required BuildContext context,
//       required Function whenAppIsUpdated}) async {
//     try {
//       final response = await get(
//         Uri.parse('${AppUrl.baseUrl}api/Patient/CheckAppSetting'),
//         headers: {
//           "Content-Type": "application/json",
//           "Access-Control-Allow-Origin": "*",
//           // Required for CORS support to work
//           // Required for cookies, authorization headers with HTTPS
//           "Access-Control-Allow-Headers":
//               "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
//           "Access-Control-Allow-Methods": "POST, OPTIONS"
//         },
//       );
//       if (response.statusCode == 200) {
//         AppSettingModel appSettingModel =
//             AppSettingModel.fromJson(jsonDecode(response.body));
//         if (appSettingModel.success ?? false) {
//           if ((appSettingModel.data ?? []).isNotEmpty) {
//             if ((appSettingModel.data?[0].taskCode ?? 0) == 2 &&
//                 (appSettingModel.data?[0].appVersion ?? "") == "0") {
//               // block user
//
//               Navigator.pushAndRemoveUntil(
//                   navigatorKey.currentContext!,
//                   MaterialPageRoute(
//                     builder: (context) => ErrorScreen(
//                         heading: "Come back later",
//                         subHeading: appSettingModel.data?[0].description ??
//                             "Something went wrong. Come after some time."),
//                   ),
//                   (route) => false);
//             } else {
//               PackageInfo.fromPlatform().then((packageInfoValue) {
//                 if ((appSettingModel.data ?? []).length > 1) {
//                   if ((appSettingModel.data?[1].taskCode ?? 0) == 3 &&
//                       (appSettingModel.data?[1].appVersion ?? "") !=
//                           packageInfoValue.version &&
//                       (appSettingModel.data?[1].rate ?? "") == "1") {
//                     // block user for update
//                     UpdateCheckerDialog.webShow(
//                         UpdateAppModel(
//                           packageName: Constants.appName,
//                           totalBytesToDownload: "10000000",
//                           availableVersionCode:
//                               (appSettingModel.data?[1].appVersion ?? ""),
//                         ),
//                         navigatorKey.currentContext!,
//                         (appSettingModel.data?[1].description ??
//                             Constants.appPlayStoreUrl));
//                   } else {
//                     // proceed user to app
//
//                     whenAppIsUpdated();
//                   }
//                 } else {
//                   Navigator.pushAndRemoveUntil(
//                       navigatorKey.currentContext!,
//                       MaterialPageRoute(
//                         builder: (context) => ErrorScreen(
//                             heading: "Failed",
//                             subHeading: appSettingModel.message ??
//                                 "Something went wrong. Come after some time."),
//                       ),
//                       (route) => false);
//                 }
//               });
//             }
//           } else {
//             Navigator.pushAndRemoveUntil(
//                 navigatorKey.currentContext!,
//                 MaterialPageRoute(
//                   builder: (context) => ErrorScreen(
//                       heading: "Failed",
//                       subHeading: appSettingModel.message ??
//                           "Something went wrong. Come after some time."),
//                 ),
//                 (route) => false);
//           }
//         } else {
//           Navigator.pushAndRemoveUntil(
//               navigatorKey.currentContext!,
//               MaterialPageRoute(
//                 builder: (context) => ErrorScreen(
//                     heading: "Failed",
//                     subHeading: appSettingModel.message ??
//                         "Something went wrong. Come after some time."),
//               ),
//               (route) => false);
//         }
//       } else {
//         Navigator.pushAndRemoveUntil(
//             navigatorKey.currentContext!,
//             MaterialPageRoute(
//               builder: (context) => const ErrorScreen(
//                   heading: "Failed",
//                   subHeading:
//                       "Something went wrong. Come after some time or restart app."),
//             ),
//             (route) => false);
//       }
//     } catch (e) {
//       Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => const ErrorScreen(
//                 heading: "Failed",
//                 subHeading:
//                     "Something went wrong. Come after some time or restart app."),
//           ),
//           (route) => false);
//     }
//   }
// }
