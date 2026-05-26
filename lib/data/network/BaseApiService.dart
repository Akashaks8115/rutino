abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getPutApiResponse(String url, dynamic data);
  Future<dynamic> getDeleteApiResponse(String url, dynamic data);

  Future<dynamic> getPatchApiResponse(String url, dynamic data);
  Future<dynamic> uploadImage(String url, dynamic data);
  // Future<dynamic> getPostUploadImageApiResponse(
  //     String url, String bearerToken, String filePath);
}
