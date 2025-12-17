import 'package:equatable/equatable.dart';

class ClientSearchModel extends Equatable {
  final String memberId;
  final String piName;
  final String nicNew;
  final String centerNo;
  final String centerName;
  final String manager;
  final String groupType;
  final String managerMemberId;
  final String lendingType;
  final String cnicStatus;
  final String isActive;
  final String branchId;
  final String branchIdName;
  final String consumerId;
  final String fatherName;
  final String piPermanentAddress;
  final String? lastBranch;
  final String lastLoanAmount;
  final String associateWithNgoSince;
  final String cyclePeriod;
  final String status;
  final String disbursId;
  final String loanPeriod;
  final String nearBranch;
  final String approvalClient;

  const ClientSearchModel({
    required this.memberId,
    required this.piName,
    required this.nicNew,
    required this.centerNo,
    required this.centerName,
    required this.manager,
    required this.groupType,
    required this.managerMemberId,
    required this.lendingType,
    required this.cnicStatus,
    required this.isActive,
    required this.branchId,
    required this.branchIdName,
    required this.consumerId,
    required this.fatherName,
    required this.piPermanentAddress,
    this.lastBranch,
    required this.lastLoanAmount,
    required this.associateWithNgoSince,
    required this.cyclePeriod,
    required this.status,
    required this.disbursId,
    required this.loanPeriod,
    required this.nearBranch,
    required this.approvalClient,
  });

  factory ClientSearchModel.fromJson(Map<String, dynamic> json) {
    return ClientSearchModel(
      memberId: json['Member_ID'] ?? '0',
      piName: json['PI_Name'] ?? '',
      nicNew: json['NIC_New'] ?? '',
      centerNo: json['CenterNo'] ?? '0',
      centerName: json['Center_Name'] ?? '0',
      manager: json['Manager'] ?? '',
      groupType: json['GroupType'] ?? '0',
      managerMemberId: json['ManagerMemberid'] ?? '0',
      lendingType: json['LendingType'] ?? '0',
      cnicStatus: json['CNIC_Status'] ?? '',
      isActive: json['isactive'] ?? '0',
      branchId: json['Branch_ID'] ?? '0',
      branchIdName: json['BranchID_Name'] ?? '',
      consumerId: json['Consumerid'] ?? '0',
      fatherName: json['FatherName'] ?? '',
      piPermanentAddress: json['PI_Permanent_Address'] ?? '',
      lastBranch: json['LastBranch'],
      lastLoanAmount: json['LastLoanAmount'] ?? '0.0000',
      associateWithNgoSince: json['AssociateWithNgoSince'] ?? '',
      cyclePeriod: json['CyclePeriod'] ?? '0',
      status: json['Status'] ?? '',
      disbursId: json['Disburs_ID'] ?? '0',
      loanPeriod: json['Loan_Period'] ?? '0',
      nearBranch: json['NearBranch'] ?? '',
      approvalClient: json['ApprovalClient'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Member_ID': memberId,
      'PI_Name': piName,
      'NIC_New': nicNew,
      'CenterNo': centerNo,
      'Center_Name': centerName,
      'Manager': manager,
      'GroupType': groupType,
      'ManagerMemberid': managerMemberId,
      'LendingType': lendingType,
      'CNIC_Status': cnicStatus,
      'isactive': isActive,
      'Branch_ID': branchId,
      'BranchID_Name': branchIdName,
      'Consumerid': consumerId,
      'FatherName': fatherName,
      'PI_Permanent_Address': piPermanentAddress,
      'LastBranch': lastBranch,
      'LastLoanAmount': lastLoanAmount,
      'AssociateWithNgoSince': associateWithNgoSince,
      'CyclePeriod': cyclePeriod,
      'Status': status,
      'Disburs_ID': disbursId,
      'Loan_Period': loanPeriod,
      'NearBranch': nearBranch,
      'ApprovalClient': approvalClient,
    };
  }

  @override
  List<Object?> get props => [memberId, nicNew, status];
}

class ClientSearchResponseModel {
  final String message;
  final List<ClientSearchModel> data;
  final String status;

  ClientSearchResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory ClientSearchResponseModel.fromJson(Map<String, dynamic> json) {
    return ClientSearchResponseModel(
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((e) => ClientSearchModel.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? 'False',
    );
  }
}
