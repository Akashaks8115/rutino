// ignore_for_file: unnecessary_new, prefer_collection_literals

class CommonModel {
  bool? success;
  String? message;
  int? statusCode;

  CommonModel({this.success, this.message, this.statusCode});

  CommonModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'] is Map
        ? (json['Message']['Message'] ??
                json['Message']['message'] ??
                (json['Message']['code'] == 'ETIMEOUT'
                    ? 'Connection Timeout. Please try again.'
                    : json['Message']['code']) ??
                'An error occurred')
            .toString()
        : json['Message']?.toString();
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = success;
    data['Message'] = message;
    data['StatusCode'] = statusCode;
    return data;
  }
}
