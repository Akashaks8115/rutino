import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../libs.dart';

class CompFunctions {
  static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
    navigatorKey.currentContext!,
    listen: false,
  );

  static Future delay({int seconds = 2}) async {
    return Future.delayed(Duration(seconds: seconds));
  }

  static Future<bool> delayWidget({int milliseconds = 300}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    return true;
  }

  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      mDebugPrint("Parsed Android SDK level (from device_info_plus): $sdkInt");

      if (sdkInt >= 33) {
        return true;
      }
    } catch (e) {
      mDebugPrint("Error reading Android SDK level: $e");

      // Fallback in case of unexpected platform errors or missing native bindings (prior to a full app rebuild)
      try {
        final sdkVersionStr = Platform.operatingSystemVersion.trim().toUpperCase();
        mDebugPrint("Fallback parsing version string: $sdkVersionStr");

        // 1. Android build IDs starting with T, U, V, W, X, Y, Z are Android 13+ (SDK >= 33)
        if (sdkVersionStr.isNotEmpty) {
          final firstLetter = sdkVersionStr[0];
          if ('TUVWXYZ'.contains(firstLetter)) {
            mDebugPrint("Bypassing permission check as build letter is $firstLetter (Android 13+)");
            return true;
          }
        }

        // 2. Direct string match fallback
        if (sdkVersionStr.contains('ANDROID 13') ||
            sdkVersionStr.contains('ANDROID 14') ||
            sdkVersionStr.contains('ANDROID 15') ||
            sdkVersionStr.contains('ANDROID 16')) {
          return true;
        }
      } catch (err) {
        mDebugPrint("Fallback parser failed: $err");
      }
    }

    try {
      final status = await Permission.storage.request();
      return status.isGranted;
    } catch (e) {
      mDebugPrint("Permission request failed: $e");
      return true;
    }
  }

  static void fieldFocusChange({
    required FocusNode currentFocusNode,
    required FocusNode nextFocusNode,
  }) {
    currentFocusNode.unfocus();
    FocusScope.of(navigatorKey.currentContext!).requestFocus(nextFocusNode);
  }

  static void setFieldFocus({required FocusNode nextFocus}) {
    FocusScope.of(navigatorKey.currentContext!).requestFocus(nextFocus);
  }

  static void unFocus() {
    FocusScope.of(navigatorKey.currentContext!).unfocus();
  }

  static String getRoundUpTo(dynamic number, {int upto = 2}) {
    if (number == 'null' || number.toString().isEmpty || number == null) {
      return "0";
    } else {
      double numb = double.parse(number.toString());

      String n = numb.toStringAsFixed(upto);
      double val = double.parse(n);
      RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
      String s = val.toString().replaceAll(regex, '');

      return numb < 0 ? "0" : s;
    }
  }

  static String getRoundUpString(String text, {int upto = 17}) {
    if (text.length > upto) {
      return "${text.substring(0, upto)}..";
    } else {
      return text;
    }
  }

  static Future<File?> getAspectImageFromGallery({
    required double ratioX,
    required double ratioY,
  }) async {
    File? docImage;

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
        compressFormat: ImageCompressFormat.png,
        maxWidth: ratioX.toInt(),
        maxHeight: ratioY.toInt(),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            backgroundColor: themeChangerViewModel.getWhiteColor,
            activeControlsWidgetColor: themeChangerViewModel.getPrimaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            cropGridColor: themeChangerViewModel.getWhiteColor,
            cropFrameColor: themeChangerViewModel.getWhiteColor,
            toolbarWidgetColor: themeChangerViewModel.getWhiteColor,
            toolbarColor: themeChangerViewModel.getPrimaryColor,
            lockAspectRatio: true,
          ),
          IOSUiSettings(minimumAspectRatio: 1.0),
        ],
      );

      if (croppedImage != null) {
        docImage = File(croppedImage.path);
        mDebugPrint(docImage.path);
      }
    }
    return docImage;
  }

  static Future<bool> getConnectivityStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }

  static Future<String> getIpAddress() async {
    String ip = '';
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            ip = addr.address;
            mDebugPrint('IP address: ${addr.address}');
          }
        }
      }
    } catch (e) {
      mDebugPrint('Failed to get IP address: $e');
    }
    return ip;
  }

  static Future<String> uploadImage(String path) async {
    // final uploadImageRepo = UploadImageRepository();

    String p = '';

    if (path.isNotEmpty) {
      // await uploadImageRepo.uploadImageAPI(path).then((value) {
      //   p = value.toString();
      // }).onError(
      //   (error, stackTrace) {
      //     CompDialog.errorDialogBox(
      //         message: "Try again", heading: "Image upload failed.");
      //   },
      // );
    }
    return p;
  }

  static String _isoToEmoji(String countryCode) {
    if (countryCode.length != 2) return countryCode;
    final String upperFlag = countryCode.toUpperCase();
    final int firstChar = upperFlag.codeUnitAt(0) + 127397;
    final int secondChar = upperFlag.codeUnitAt(1) + 127397;
    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }

  static Future<String> convertToFlagEmoji(String countryName) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/json/countryCodes.json',
      );
      final List<dynamic> data = json.decode(response);

      final countryData = data.firstWhere(
        (element) =>
            element['country']?.toString().toLowerCase() ==
            countryName.toLowerCase(),
        orElse: () => null,
      );

      if (countryData != null) {
        return _isoToEmoji(countryData['flag'] ?? "");
      }
    } catch (e) {
      mDebugPrint('Error getting flag emoji by name: $e');
    }
    return "";
  }

  static Future<String> getFlagEmojiByCountryName(String countryName) async {
    return convertToFlagEmoji(countryName);
  }

  static Future<String> getFlagEmojiByDialingCode(String dialingCode) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/json/countryCodes.json',
      );
      final List<dynamic> data = json.decode(response);

      final countryData = data.firstWhere(
        (element) => element['code']?.toString() == dialingCode,
        orElse: () => null,
      );

      if (countryData != null) {
        return _isoToEmoji(countryData['flag'] ?? "");
      }
    } catch (e) {
      mDebugPrint('Error getting flag emoji by dialing code: $e');
    }
    return "";
  }
}
