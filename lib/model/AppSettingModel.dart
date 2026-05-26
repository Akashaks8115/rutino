class AppSettingModel {
  bool? success;
  String? message;
  List<APPDetails>? data;

  AppSettingModel({this.success, this.message, this.data});

  AppSettingModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'] is Map
        ? (json['Message']['Message'] ??
              json['Message']['message'] ??
              json['Message']['code'] ??
              'An error occurred')
        : json['Message']?.toString();
    if (json['Data'] != null) {
      data = <APPDetails>[];
      json['Data'].forEach((v) {
        data!.add(APPDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Success'] = success;
    data['Message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class APPDetails {
  int? id;
  String? appVersion;
  String? description;
  int? taskCode;
  String? rate;

  APPDetails({
    this.id,
    this.appVersion,
    this.description,
    this.taskCode,
    this.rate,
  });

  APPDetails.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    appVersion = json['AppVersion'];
    description = json['Description'];
    taskCode = json['TaskCode'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['AppVersion'] = appVersion;
    data['Description'] = description;
    data['TaskCode'] = taskCode;
    data['Rate'] = rate;
    return data;
  }
}
