class CreditOfficerResponseModel {
  final String message;
  final List<CreditOfficerModel> data;
  final String status;

  CreditOfficerResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory CreditOfficerResponseModel.fromJson(Map<String, dynamic> json) {
    return CreditOfficerResponseModel(
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((e) => CreditOfficerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] ?? '',
    );
  }
}

class CreditOfficerModel {
  final String userId;
  final String userName;

  CreditOfficerModel({
    required this.userId,
    required this.userName,
  });

  factory CreditOfficerModel.fromJson(Map<String, dynamic> json) {
    return CreditOfficerModel(
      userId: json['User_ID']?.toString() ?? '',
      userName: json['User_Name']?.toString() ?? '',
    );
  }
}
