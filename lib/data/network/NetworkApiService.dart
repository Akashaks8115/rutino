// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
//
// import '../../libs.dart';
//
// class NetworkApiService extends BaseApiServices {
//   @override
//   @override
//   Future<dynamic> getGetApiResponse(String url) async {
//     mDebugPrintApi("Get $url");
//     dynamic responseJson;
//
//     try {
//       String? token = Provider.of<SharedPrefViewModel>(
//         navigatorKey.currentContext!,
//         listen: false,
//       ).getLoginModel.data?.first.token;
//
//       mDebugPrint("Token: $token");
//
//       Map<String, String> headers = {
//         "Accept": "application/json",
//         "Content-Type": "application/json",
//       };
//
//       if (token != null && token.isNotEmpty) {
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       final response = await http
//           .get(Uri.parse(url), headers: headers)
//           .timeout(const Duration(seconds: 30));
//
//       responseJson = returnResponse(response);
//     } on SocketException {
//       responseJson = CommonModel(
//         message: "No Internet Connection",
//         success: false,
//       ).toJson();
//     } on TimeoutException {
//       responseJson = CommonModel(
//         message: "Request Timeout. Please try again.",
//         success: false,
//       ).toJson();
//     } catch (e) {
//       responseJson = CommonModel(
//         message: "Something went wrong: ${e.toString()}",
//         success: false,
//       ).toJson();
//     }
//
//     mDebugPrintResponse(responseJson);
//     return responseJson;
//   }
//
//   @override
//   Future<dynamic> getPostApiResponse(String url, dynamic data) async {
//     String body = json.encode(data);
//
//     mDebugPrintApi("Post $url");
//     mDebugPrintRequest(data);
//
//     dynamic responseJson;
//
//     try {
//       String? token = Provider.of<SharedPrefViewModel>(
//         navigatorKey.currentContext!,
//         listen: false,
//       ).getLoginModel.data?.first.token;
//       //
//       mDebugPrint(token);
//
//       Map<String, String> headers = {
//         "accept": "*/*",
//         "Content-Type": "application/json",
//         "Access-Control-Allow-Origin": "*",
//         "Access-Control-Allow-Headers":
//             "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
//         "Access-Control-Allow-Methods": "POST, OPTIONS",
//       };
//
//       if (token != null && token.isNotEmpty) {
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       http.Response response = await http
//           .post(Uri.parse(url), headers: headers, body: body)
//           .timeout(const Duration(seconds: 30));
//
//       responseJson = returnResponse(response);
//     } on SocketException {
//       responseJson = CommonModel(
//         message: "No Internet Connection",
//         success: false,
//       ).toJson();
//     } on TimeoutException {
//       responseJson = CommonModel(
//         message: "Request Timeout. Please try again.",
//         success: false,
//       ).toJson();
//     } catch (e) {
//       responseJson = CommonModel(
//         message: "Something went wrong: ${e.toString()}",
//         success: false,
//       ).toJson();
//     }
//     mDebugPrintResponse(responseJson);
//     return responseJson;
//   }
//
//   @override
//   Future<dynamic> getDeleteApiResponse(String url, dynamic data) async {
//     String body = json.encode(data);
//
//     mDebugPrintApi("Delete $url");
//     mDebugPrintRequest(data);
//
//     dynamic responseJson;
//
//     try {
//       String? token = Provider.of<SharedPrefViewModel>(
//         navigatorKey.currentContext!,
//         listen: false,
//       ).getLoginModel.data?.first.token;
//
//       Map<String, String> headers = {
//         "accept": "*/*",
//         "Content-Type": "application/json",
//         "Access-Control-Allow-Origin": "*", // Required for CORS support to work
//         "Access-Control-Allow-Headers":
//             "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
//         "Access-Control-Allow-Methods": "POST, OPTIONS",
//       };
//
//       if (token != null && token.isNotEmpty) {
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       http.Response response = await http
//           .delete(Uri.parse(url), headers: headers, body: body)
//           .timeout(const Duration(seconds: 30));
//
//       responseJson = returnResponse(response);
//     } on SocketException {
//       responseJson = CommonModel(
//         message: "No Internet Connection",
//         success: false,
//       ).toJson();
//     } on TimeoutException {
//       responseJson = CommonModel(
//         message: "Request Timeout. Please try again.",
//         success: false,
//       ).toJson();
//     } catch (e) {
//       responseJson = CommonModel(
//         message: "Something went wrong: ${e.toString()}",
//         success: false,
//       ).toJson();
//     }
//     mDebugPrintResponse(responseJson);
//     return responseJson;
//   }
//
//   @override
//   Future<dynamic> getPatchApiResponse(String url, dynamic data) async {
//     String body = json.encode(data);
//
//     mDebugPrintApi("Patch $url");
//     mDebugPrintRequest(data);
//
//     dynamic responseJson;
//
//     try {
//       String? token = Provider.of<SharedPrefViewModel>(
//         navigatorKey.currentContext!,
//         listen: false,
//       ).getLoginModel.data?.first.token;
//
//       Map<String, String> headers = {
//         "accept": "*/*",
//         "Content-Type": "application/json",
//         "Access-Control-Allow-Origin": "*", // Required for CORS support to work
//         "Access-Control-Allow-Headers":
//             "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
//         "Access-Control-Allow-Methods": "POST, OPTIONS",
//       };
//
//       if (token != null && token.isNotEmpty) {
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       http.Response response = await http
//           .patch(Uri.parse(url), headers: headers, body: body)
//           .timeout(const Duration(seconds: 30));
//
//       responseJson = returnResponse(response);
//     } on SocketException {
//       responseJson = CommonModel(
//         message: "No Internet Connection",
//         success: false,
//       ).toJson();
//     } on TimeoutException {
//       responseJson = CommonModel(
//         message: "Request Timeout. Please try again.",
//         success: false,
//       ).toJson();
//     } catch (e) {
//       responseJson = CommonModel(
//         message: "Something went wrong: ${e.toString()}",
//         success: false,
//       ).toJson();
//     }
//     mDebugPrintResponse(responseJson);
//     return responseJson;
//   }
//
//   @override
//   Future<dynamic> getPutApiResponse(String url, dynamic data) async {
//     String body = json.encode(data);
//
//     mDebugPrintApi("Put $url");
//     mDebugPrintRequest(data);
//
//     dynamic responseJson;
//
//     try {
//       String? token = Provider.of<SharedPrefViewModel>(
//         navigatorKey.currentContext!,
//         listen: false,
//       ).getLoginModel.data?.first.token;
//
//       Map<String, String> headers = {
//         "accept": "*/*",
//         "Content-Type": "application/json",
//         "Access-Control-Allow-Origin": "*",
//         "Access-Control-Allow-Headers":
//             "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
//         "Access-Control-Allow-Methods": "POST, OPTIONS",
//       };
//
//       if (token != null && token.isNotEmpty) {
//         headers["Authorization"] = "Bearer $token";
//       }
//
//       http.Response response = await http
//           .put(Uri.parse(url), headers: headers, body: body)
//           .timeout(const Duration(seconds: 30));
//
//       responseJson = returnResponse(response);
//     } on SocketException {
//       responseJson = CommonModel(
//         message: "No Internet Connection",
//         success: false,
//       ).toJson();
//     } on TimeoutException {
//       responseJson = CommonModel(
//         message: "Request Timeout. Please try again.",
//         success: false,
//       ).toJson();
//     } catch (e) {
//       responseJson = CommonModel(
//         message: "Something went wrong: ${e.toString()}",
//         success: false,
//       ).toJson();
//     }
//     mDebugPrintResponse(responseJson);
//     return responseJson;
//   }
//
//   @override
//   Future uploadImage(String url, dynamic data) async {
//     try {
//       String? token = Provider.of<SharedPrefViewModel>(
//         navigatorKey.currentContext!,
//         listen: false,
//       ).getLoginModel.data?.first.token;
//
//       final File file = File(data);
//
//       final request = http.MultipartRequest('POST', Uri.parse(url));
//
//       request.headers['Authorization'] = 'Bearer $token';
//       request.headers['accept'] = 'application/json';
//       request.headers['Content-Type'] = 'multipart/form-data';
//
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'file',
//           file.path,
//           contentType: MediaType('image', 'png'),
//         ),
//       );
//
//       final response = await request.send().timeout(
//         const Duration(seconds: 60),
//       );
//
//       if (response.statusCode == 200) {
//         String responseBody = await response.stream.bytesToString();
//         dynamic jsonData = jsonDecode(responseBody);
//
//         return jsonData;
//       } else {
//         return {
//           "Success": false,
//           "Message": "Failed to upload image. Status: ${response.statusCode}",
//           "ImageUrl": "",
//         };
//       }
//     } on SocketException {
//       return {
//         "Success": false,
//         "Message": "No Internet Connection",
//         "ImageUrl": "",
//       };
//     } on TimeoutException {
//       return {
//         "Success": false,
//         "Message": "Upload Timeout. Please try again.",
//         "ImageUrl": "",
//       };
//     } catch (e) {
//       return {
//         "Success": false,
//         "Message": "Something went wrong: ${e.toString()}",
//         "ImageUrl": "",
//       };
//     }
//   }
//
//   dynamic returnResponse(http.Response response) {
//     dynamic responseJson = jsonDecode(response.body);
//
//     if (responseJson is Map) {
//       if (!responseJson.containsKey('StatusCode')) {
//         responseJson['StatusCode'] = response.statusCode;
//       }
//       if (!responseJson.containsKey('Success')) {
//         responseJson['Success'] =
//             response.statusCode >= 200 && response.statusCode < 300;
//       }
//     }
//
//     switch (response.statusCode) {
//       case 200:
//       case 201:
//       case 401:
//       case 422:
//       case 500:
//         return responseJson;
//       case 502:
//         return CommonModel(
//           message: "Sorry for inconvenience. We will come back soon.",
//           success: false,
//           statusCode: 502,
//         ).toJson();
//       default:
//         mDebugPrintError(response.statusCode.toString());
//         return CommonModel(
//           message: Constants.defaultError,
//           success: false,
//           statusCode: response.statusCode,
//         ).toJson();
//     }
//   }
// }
