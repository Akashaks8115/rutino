// import '../libs.dart';
//
// class AddressRepository {
//   BaseApiServices apiServices = NetworkApiService();
//
//   Future<AddressModel> getAddressApi(dynamic data) async {
//     try {
//       dynamic response = await apiServices.getPostApiResponse(
//         AppUrl.getAddressUrl,
//         data,
//       );
//
//       return AddressModel.fromJson(response);
//     } catch (e) {
//       return AddressModel(success: false, message: Constants.defaultError);
//     }
//   }
//
//   Future<CommonModel> insertAddressApi(dynamic data) async {
//     try {
//       dynamic response = await apiServices.getPostApiResponse(
//         AppUrl.insertAddressUrl,
//         data,
//       );
//
//       return CommonModel.fromJson(response);
//     } catch (e) {
//       return CommonModel(success: false, message: Constants.defaultError);
//     }
//   }
//
//   Future<CommonModel> updateAddressApi(dynamic data) async {
//     try {
//       dynamic response = await apiServices.getPutApiResponse(
//         AppUrl.updateAddressUrl,
//         data,
//       );
//
//       return CommonModel.fromJson(response);
//     } catch (e) {
//       return CommonModel(success: false, message: Constants.defaultError);
//     }
//   }
// }
