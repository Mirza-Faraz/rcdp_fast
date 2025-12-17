import 'package:equatable/equatable.dart';

class BranchModel extends Equatable {
  final int branchId;
  final String branchName;

  const BranchModel({
    required this.branchId,
    required this.branchName,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['Branch_ID'] ?? 0,
      branchName: json['BranchID_Name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Branch_ID': branchId,
      'BranchID_Name': branchName,
    };
  }

  @override
  List<Object?> get props => [branchId, branchName];
}

class BranchResponseModel {
  final String message;
  final List<BranchModel> data;
  final String status;

  BranchResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory BranchResponseModel.fromJson(Map<String, dynamic> json) {
    return BranchResponseModel(
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((e) => BranchModel.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? 'False',
    );
  }
}
