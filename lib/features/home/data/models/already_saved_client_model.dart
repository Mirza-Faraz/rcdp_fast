import 'package:equatable/equatable.dart';

class AlreadySavedClientModel extends Equatable {
  final String srNo;
  final String clientId;
  final String clientName;
  final String clientCnic;

  const AlreadySavedClientModel({
    required this.srNo,
    required this.clientId,
    required this.clientName,
    required this.clientCnic,
  });

  factory AlreadySavedClientModel.fromJson(Map<String, dynamic> json) {
    return AlreadySavedClientModel(
      srNo: json['Sr#']?.toString() ?? '',
      clientId: json['Member_ID']?.toString() ?? '',
      clientName: json['PI_Name']?.toString() ?? '',
      clientCnic: json['CNIC']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Sr#': srNo,
      'Member_ID': clientId,
      'PI_Name': clientName,
      'CNIC': clientCnic,
    };
  }

  @override
  List<Object?> get props => [srNo, clientId, clientName, clientCnic];
}

class AlreadySavedClientsResponseModel extends Equatable {
  final String message;
  final List<AlreadySavedClientModel> data;
  final String status;

  const AlreadySavedClientsResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory AlreadySavedClientsResponseModel.fromJson(Map<String, dynamic> json) {
    return AlreadySavedClientsResponseModel(
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => AlreadySavedClientModel.fromJson(e))
              .toList()
          : [],
      status: json['status']?.toString() ?? 'False',
    );
  }

  @override
  List<Object?> get props => [message, data, status];
}
