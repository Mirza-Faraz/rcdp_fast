class ClientCreateRequest {
  final String nicNew;
  final String cnicStatus;
  final int? nomineeCareOff;
  final String? nomineeTokenNo;
  final String? piSpouseTokenNo;
  final String? tokenNo;
  final String userId;
  final int branchOfficeId;
  final int? clientCareOff;
  final String clientCareoffName;
  final String piPhoneNo;
  final String expiryNic;
  final String piDob;
  final int piEducation;
  final String piExistingAddress;
  final String fatherName;
  final int piGender;
  final dynamic memberId; // Can be int or string based on examples
  final String latitude;
  final String longitude;
  final int piMaritalStatus;
  final String piName;
  final String? nomineeCnic;
  final String? nomineeExpiryNic;
  final String? nomineeCareoffName;
  final String? nomineeDob;
  final String? nomineeName;
  final String? nomineePhoneNo;
  final String piPermanentAddress;
  final String piPresentAddress;
  final String religion;
  final String? piSpouseCnic;
  final String? piSpouseExpiryNic;
  final String? piSpouseDob;
  final String? extraField2; // Guardian name in example
  final String? spousePhoneNo;
  final int piVillage;

  ClientCreateRequest({
    required this.nicNew,
    required this.cnicStatus,
    this.nomineeCareOff,
    this.nomineeTokenNo,
    this.piSpouseTokenNo,
    this.tokenNo,
    required this.userId,
    required this.branchOfficeId,
    this.clientCareOff,
    required this.clientCareoffName,
    required this.piPhoneNo,
    required this.expiryNic,
    required this.piDob,
    required this.piEducation,
    required this.piExistingAddress,
    required this.fatherName,
    required this.piGender,
    required this.memberId,
    required this.latitude,
    required this.longitude,
    required this.piMaritalStatus,
    required this.piName,
    this.nomineeCnic,
    this.nomineeExpiryNic,
    this.nomineeCareoffName,
    this.nomineeDob,
    this.nomineeName,
    this.nomineePhoneNo,
    required this.piPermanentAddress,
    required this.piPresentAddress,
    required this.religion,
    this.piSpouseCnic,
    this.piSpouseExpiryNic,
    this.piSpouseDob,
    this.extraField2,
    this.spousePhoneNo,
    required this.piVillage,
  });

  Map<String, dynamic> toJson() {
    return {
      "NIC_New": nicNew,
      "CNIC_Status": cnicStatus,
      "Nominee_Care_Off": nomineeCareOff,
      "Nominee_TokenNo": nomineeTokenNo ?? "",
      "PI_Spouse_TokenNo": piSpouseTokenNo ?? "",
      "Token_No": tokenNo ?? "",
      "User_ID": userId,
      "Branch_Office_ID": branchOfficeId,
      "Client_Care_Off": clientCareOff,
      "Client_Careoff_Name": clientCareoffName,
      "PI_Phone_No": piPhoneNo,
      "Expiry_NIC": expiryNic,
      "PI_DOB": piDob,
      "PI_Education": piEducation,
      "PI_Existing_Address": piExistingAddress,
      "FatherName": fatherName,
      "PI_Gender": piGender,
      "Member_ID": memberId,
      "latitude": latitude,
      "longitude": longitude,
      "PI_Marital_Status": piMaritalStatus,
      "PI_Name": piName,
      "Nominee_CNIC": nomineeCnic ?? "",
      "Nominee_Expiry_NIC": nomineeExpiryNic ?? "",
      "Nominee_Careoff_Name": nomineeCareoffName ?? "",
      "Nominee_DOB": nomineeDob ?? "",
      "Nominee_Name": nomineeName ?? "",
      "Nominee_Phone_No": nomineePhoneNo ?? "",
      "PI_Permanent_Address": piPermanentAddress,
      "PI_Present_Address": piPresentAddress,
      "Religion": religion,
      "PI_Spouse_CNIC": piSpouseCnic ?? "",
      "PI_Spouse_Expiry_NIC": piSpouseExpiryNic ?? "",
      "PI_Spouse_DOB": piSpouseDob ?? "",
      "ExtraField2": extraField2 ?? "",
      "Spouse_Phone_No": spousePhoneNo ?? "",
      "PI_Village": piVillage,
    };
  }
}
