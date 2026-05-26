import 'dart:convert';

import 'package:flutter/foundation.dart';

void mDebugPrint(dynamic msg) {
  if (kDebugMode) {
    debugPrint(msg.toString());
  }
}

void mDebugPrintApi(dynamic msg) {
  if (kDebugMode) {
    mDebugPrint(
      "------------------------------------$msg----------------------------------------",
    );
  }
}

void mDebugPrintApi2(dynamic msg) {
  if (kDebugMode) {
    print(
      "------------------------------------$msg----------------------------------------",
    );
  }
}

void mDebugPrintRequest(dynamic data) {
  if (kDebugMode) {
    mDebugPrint("Request : ${jsonEncode(data)}");
  }
}

void mDebugPrintResponse(dynamic response) {
  if (kDebugMode) {
    mDebugPrint("Response : ${jsonEncode(response)}");
  }
}

void mDebugPrintError(dynamic msg) {
  if (kDebugMode) {
    mDebugPrint("Error : ${jsonEncode(msg)}");
  }
}
