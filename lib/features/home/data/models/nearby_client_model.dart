import 'package:equatable/equatable.dart';

class NearbyClientModel extends Equatable {
  final String memberId;
  final String nicNew;
  final String piName;
  final String piDob;
  final String expiryNic;
  final String? piPhoneNo;
  final int piGender;
  final String? educationDescription;
  final int piMaritalStatus;
  final String? religion;
  final String? piPresentAddress;
  final String? piPermanentAddress;
  final String? description;
  final String? nomineeName;
  final String nomineeDob;
  final String? nomineeCnic;
  final String nomineeExpiryNic;
  final String? clientCareoffName;
  final int piEducation;
  final String piVillage;
  final int clientCareOff;
  final int branchOfficeId;
  final String? fatherName;
  final String? extraField2;
  final String? latitude;
  final String? longitude;
  final String distance;

  const NearbyClientModel({
    required this.memberId,
    required this.nicNew,
    required this.piName,
    required this.piDob,
    required this.expiryNic,
    this.piPhoneNo,
    required this.piGender,
    this.educationDescription,
    required this.piMaritalStatus,
    this.religion,
    this.piPresentAddress,
    this.piPermanentAddress,
    this.description,
    this.nomineeName,
    required this.nomineeDob,
    this.nomineeCnic,
    required this.nomineeExpiryNic,
    this.clientCareoffName,
    required this.piEducation,
    required this.piVillage,
    required this.clientCareOff,
    required this.branchOfficeId,
    this.fatherName,
    this.extraField2,
    this.latitude,
    this.longitude,
    required this.distance,
  });

  factory NearbyClientModel.fromJson(Map<String, dynamic> json) {
    return NearbyClientModel(
      memberId: json['Member_ID'] ?? '',
      nicNew: json['NIC_New'] ?? '',
      piName: json['PI_Name'] ?? '',
      piDob: json['PI_DOB'] ?? '',
      expiryNic: json['Expiry_NIC'] ?? '',
      piPhoneNo: json['PI_Phone_No'],
      piGender: json['PI_Gender'] ?? 0,
      educationDescription: json['Education_Description'],
      piMaritalStatus: json['PI_Marital_Status'] ?? 0,
      religion: json['Religion'],
      piPresentAddress: json['PI_Present_Address'],
      piPermanentAddress: json['PI_Permanent_Address'],
      description: json['Description'],
      nomineeName: json['Nominee_Name'],
      nomineeDob: json['Nominee_DOB'] ?? '',
      nomineeCnic: json['Nominee_CNIC'],
      nomineeExpiryNic: json['Nominee_Expiry_NIC'] ?? '',
      clientCareoffName: json['Client_Careoff_Name'],
      piEducation: json['PI_Education'] ?? 0,
      piVillage: json['PI_Village'] ?? '',
      clientCareOff: json['Client_Care_Off'] ?? 0,
      branchOfficeId: json['Branch_Office_ID'] ?? 0,
      fatherName: json['FatherName'],
      extraField2: json['ExtraField2'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distance: json['Distance'] ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Member_ID': memberId,
      'NIC_New': nicNew,
      'PI_Name': piName,
      'PI_DOB': piDob,
      'Expiry_NIC': expiryNic,
      'PI_Phone_No': piPhoneNo,
      'PI_Gender': piGender,
      'Education_Description': educationDescription,
      'PI_Marital_Status': piMaritalStatus,
      'Religion': religion,
      'PI_Present_Address': piPresentAddress,
      'PI_Permanent_Address': piPermanentAddress,
      'Description': description,
      'Nominee_Name': nomineeName,
      'Nominee_DOB': nomineeDob,
      'Nominee_CNIC': nomineeCnic,
      'Nominee_Expiry_NIC': nomineeExpiryNic,
      'Client_Careoff_Name': clientCareoffName,
      'PI_Education': piEducation,
      'PI_Village': piVillage,
      'Client_Care_Off': clientCareOff,
      'Branch_Office_ID': branchOfficeId,
      'FatherName': fatherName,
      'ExtraField2': extraField2,
      'latitude': latitude,
      'longitude': longitude,
      'Distance': distance,
    };
  }

  @override
  List<Object?> get props => [
        memberId,
        nicNew,
        piName,
        piDob,
        expiryNic,
        piPhoneNo,
        piGender,
        educationDescription,
        piMaritalStatus,
        religion,
        piPresentAddress,
        piPermanentAddress,
        description,
        nomineeName,
        nomineeDob,
        nomineeCnic,
        nomineeExpiryNic,
        clientCareoffName,
        piEducation,
        piVillage,
        clientCareOff,
        branchOfficeId,
        fatherName,
        extraField2,
        latitude,
        longitude,
        distance,
      ];
}

class NearbyClientsResponseModel extends Equatable {
  final String message;
  final List<NearbyClientModel> data;
  final String status;

  const NearbyClientsResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory NearbyClientsResponseModel.fromJson(Map<String, dynamic> json) {
    return NearbyClientsResponseModel(
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List).map((e) => NearbyClientModel.fromJson(e)).toList()
          : [],
      status: json['status'] ?? 'False',
    );
  }

  @override
  List<Object?> get props => [message, data, status];
}
