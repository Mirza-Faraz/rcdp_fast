class EducationModel {
  final int educationId;
  final String educationDescription;

  EducationModel({
    required this.educationId,
    required this.educationDescription,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      educationId: json['Education_ID'],
      educationDescription: json['Education_Description'],
    );
  }
}

class EducationResponseModel {
  final String message;
  final String status;
  final List<EducationModel> data;

  EducationResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory EducationResponseModel.fromJson(Map<String, dynamic> json) {
    return EducationResponseModel(
      message: json['message'],
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => EducationModel.fromJson(e))
          .toList(),
    );
  }
}

class VillageModel {
  final String id;
  final String description;

  VillageModel({
    required this.id,
    required this.description,
  });

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(
      id: json['ID'].toString(),
      description: json['Description'],
    );
  }
}

class VillageResponseModel {
  final String message;
  final String status;
  final List<VillageModel> data;

  VillageResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory VillageResponseModel.fromJson(Map<String, dynamic> json) {
    return VillageResponseModel(
      message: json['message'],
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => VillageModel.fromJson(e))
          .toList(),
    );
  }
}

class RelationModel {
  final int applicantRelationId;
  final String applicantRelationDescription;

  RelationModel({
    required this.applicantRelationId,
    required this.applicantRelationDescription,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) {
    return RelationModel(
      applicantRelationId: json['ApplicantRelation_ID'],
      applicantRelationDescription: json['ApplicantRelation_Description'],
    );
  }
}

class RelationResponseModel {
  final String message;
  final String status;
  final List<RelationModel> data;

  RelationResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory RelationResponseModel.fromJson(Map<String, dynamic> json) {
    return RelationResponseModel(
      message: json['message'],
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => RelationModel.fromJson(e))
          .toList(),
    );
  }
}
