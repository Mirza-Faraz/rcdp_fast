import 'package:equatable/equatable.dart';
import 'dart:convert';
import '../../domain/entities/user_entity.dart';

class LoginResponseModel extends Equatable {
  final bool success;
  final String token;
  final UserDescriptionModel userDescription;

  const LoginResponseModel({required this.success, required this.token, required this.userDescription});

  // Factory constructor to create from JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      userDescription: json['UserDescription'] != null ? UserDescriptionModel.fromJson(json['UserDescription']) : UserDescriptionModel.empty(),
    );
  }

  // Convert to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {'success': success, 'token': token, 'UserDescription': userDescription.toJson()};
  }

  // Convert to Entity (optional, if you need to convert to domain entity)
  UserEntity toEntity() {
    return UserEntity(
      username: userDescription.userName,
      password: '', // Never store password in entity
    );
  }

  @override
  List<Object?> get props => [success, token, userDescription];
}

class UserDescriptionModel extends Equatable {
  final String designation;
  final String userBranch;
  final String userName;
  final int userId;
  final int designationId;
  final int groupId;
  final int businessInfoReq;
  final int loadUtByProduct;

  const UserDescriptionModel({
    required this.designation,
    required this.userBranch,
    required this.userName,
    required this.userId,
    required this.designationId,
    required this.groupId,
    required this.businessInfoReq,
    required this.loadUtByProduct,
  });

  // Empty constructor for default values
  factory UserDescriptionModel.empty() {
    return const UserDescriptionModel(designation: '', userBranch: '', userName: '', userId: 0, designationId: 0, groupId: 0, businessInfoReq: 0, loadUtByProduct: 0);
  }

  factory UserDescriptionModel.fromJson(Map<String, dynamic> json) {
    return UserDescriptionModel(
      designation: json['Designation'] ?? '',
      userBranch: json['UserBranch'] ?? '',
      userName: json['UserName'] ?? '',
      userId: json['UserId'] ?? 0,
      designationId: json['DesignationId'] ?? 0,
      groupId: json['Group_ID'] ?? 0,
      businessInfoReq: json['BusinessInfoReq'] ?? 0,
      loadUtByProduct: json['LoadUtByProduct'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Designation': designation,
      'UserBranch': userBranch,
      'UserName': userName,
      'UserId': userId,
      'DesignationId': designationId,
      'Group_ID': groupId,
      'BusinessInfoReq': businessInfoReq,
      'LoadUtByProduct': loadUtByProduct,
    };
  }

  // Convert to JSON string for SharedPreferences storage
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Create from JSON string
  factory UserDescriptionModel.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserDescriptionModel.fromJson(json);
  }

  @override
  List<Object?> get props => [designation, userBranch, userName, userId, designationId, groupId, businessInfoReq, loadUtByProduct];
}
