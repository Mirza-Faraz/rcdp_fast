import 'package:equatable/equatable.dart';

class LoanTrackingModel extends Equatable {
  final String? _srNo;
  final String? _cnic;
  final String? _clientId;
  final String? _clientName;
  final String? _amount;
  final String? _isApproved;
  final String? _isPosted;
  final String? _approvalProgress;
  final String? _clientStatus;

  String get srNo => _srNo ?? '';
  String get cnic => _cnic ?? '';
  String get clientId => _clientId ?? '';
  String get clientName => _clientName ?? '';
  String get amount => _amount ?? '0';
  String get isApproved => _isApproved ?? 'No';
  String get isPosted => _isPosted ?? '';
  String get approvalProgress => _approvalProgress ?? '0/0';
  String get clientStatus => _clientStatus ?? '';

  const LoanTrackingModel({
    String? srNo,
    String? cnic,
    String? clientId,
    String? clientName,
    String? amount,
    String? isApproved,
    String? isPosted,
    String? approvalProgress,
    String? clientStatus,
  })  : _srNo = srNo,
        _cnic = cnic,
        _clientId = clientId,
        _clientName = clientName,
        _amount = amount,
        _isApproved = isApproved,
        _isPosted = isPosted,
        _approvalProgress = approvalProgress,
        _clientStatus = clientStatus;

  factory LoanTrackingModel.fromJson(Map<String, dynamic> json) {
    return LoanTrackingModel(
      srNo: (json['Sr#'] ?? json['SrNo'] ?? json['Sr_No'] ?? json['sr'])?.toString(),
      cnic: (json['CNIC'] ?? json['NIC_New'] ?? json['NIC'] ?? json['Cnic'])?.toString(),
      clientId: json['Member_ID']?.toString(),
      clientName: json['PI_Name']?.toString(),
      amount: json['Disb_Amount']?.toString(),
      isApproved: json['IsApproved']?.toString(),
      isPosted: json['IsPosted']?.toString(),
      approvalProgress: json['ApprovalStages']?.toString(),
      clientStatus: (json['Status'] ?? json['Case_Status'] ?? json['Approvel'] ?? json['LoanStatus'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Sr#': srNo,
      'CNIC': cnic,
      'Member_ID': clientId,
      'PI_Name': clientName,
      'Disb_Amount': amount,
      'IsApproved': isApproved,
      'IsPosted': isPosted,
      'ApprovalStages': approvalProgress,
      'Status': clientStatus,
    };
  }

  @override
  List<Object?> get props => [
        srNo,
        cnic,
        clientId,
        clientName,
        amount,
        isApproved,
        isPosted,
        approvalProgress,
        clientStatus,
      ];
}

class LoanTrackingResponseModel extends Equatable {
  final String message;
  final List<LoanTrackingModel> data;
  final String status;

  const LoanTrackingResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory LoanTrackingResponseModel.fromJson(Map<String, dynamic> json) {
    return LoanTrackingResponseModel(
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => LoanTrackingModel.fromJson(e))
              .toList()
          : [],
      status: json['status']?.toString() ?? 'False',
    );
  }

  @override
  List<Object?> get props => [message, data, status];
}
