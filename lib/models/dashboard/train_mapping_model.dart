class TrainMappingModel {
  final String inspectionId;
  final String trainNumber;
  final List<CoachMapping> coaches;

  const TrainMappingModel({
    required this.inspectionId,
    required this.trainNumber,
    required this.coaches,
  });

  factory TrainMappingModel.fromJson(Map<String, dynamic> json) {
    return TrainMappingModel(
      inspectionId: json['inspection_id'] as String,
      trainNumber: json['train_number'] as String,
      coaches: (json['coaches'] as List<dynamic>)
          .map((e) => CoachMapping.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CoachMapping {
  final String coachNumber;
  final String coachType;
  final String mappingStatus;
  final String inspectionStatus;

  const CoachMapping({
    required this.coachNumber,
    required this.coachType,
    required this.mappingStatus,
    required this.inspectionStatus,
  });

  factory CoachMapping.fromJson(Map<String, dynamic> json) {
    return CoachMapping(
      coachNumber: json['coach_number'] as String,
      coachType: json['coach_type'] as String,
      mappingStatus: json['mapping_status'] as String,
      inspectionStatus: json['inspection_status'] as String,
    );
  }
}