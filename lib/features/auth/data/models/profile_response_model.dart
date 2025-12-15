import 'dart:convert';
import 'package:equatable/equatable.dart';

class ProfileResponseModel extends Equatable {
  final String message;
  final List<ProfileDataModel> data;
  final String status;

  const ProfileResponseModel({required this.message, required this.data, required this.status});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      message: json['message'] ?? '',
      data: json['data'] != null ? (json['data'] as List).map((item) => ProfileDataModel.fromJson(item)).toList() : [],
      status: json['status'] ?? 'False',
    );
  }

  // Get first profile if available
  ProfileDataModel? get firstProfile => data.isNotEmpty ? data.first : null;

  // Check if response is successful
  bool get isSuccess => status.toLowerCase() == 'true' && data.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data.map((item) => item.toJson()).toList(), 'status': status};
  }

  @override
  List<Object?> get props => [message, data, status];
}

class ProfileDataModel extends Equatable {
  final String userId;
  final String userName;
  final String branchNames;
  final String? userPhone;
  final String? userEmail;
  final String accountExpiryDate;
  final String designationDescription;
  final String groupName;
  final String? thumbImpression;

  const ProfileDataModel({
    required this.userId,
    required this.userName,
    required this.branchNames,
    this.userPhone,
    this.userEmail,
    required this.accountExpiryDate,
    required this.designationDescription,
    required this.groupName,
    this.thumbImpression,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      userId: json['User_ID']?.toString() ?? '',
      userName: json['User_Name'] ?? '',
      branchNames: json['BranchNames'] ?? '',
      userPhone: json['User_Phone'],
      userEmail: json['User_Email'],
      accountExpiryDate: json['AccountExpiryDate'] ?? '',
      designationDescription: json['Designation_Description'] ?? '',
      groupName: json['Group_Name'] ?? '',
      thumbImpression: json['ThumbImpression'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'User_ID': userId,
      'User_Name': userName,
      'BranchNames': branchNames,
      'User_Phone': userPhone,
      'User_Email': userEmail,
      'AccountExpiryDate': accountExpiryDate,
      'Designation_Description': designationDescription,
      'Group_Name': groupName,
      'ThumbImpression': thumbImpression,
    };
  }

  // Convert to JSON string for SharedPreferences storage
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Create from JSON string
  factory ProfileDataModel.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return ProfileDataModel.fromJson(json);
  }

  @override
  List<Object?> get props => [userId, userName, branchNames, userPhone, userEmail, accountExpiryDate, designationDescription, groupName, thumbImpression];
}
