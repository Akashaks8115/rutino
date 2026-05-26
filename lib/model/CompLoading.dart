import '../libs.dart';

class LoadingModel {
  Status status;
  String message;
  int? statusCode;
  LoadingModel({
    this.status = Status.LOADING,
    this.message = "Something went wrong",
    this.statusCode,
  });
}
