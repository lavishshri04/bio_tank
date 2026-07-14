class CoachListModel {
  final String inspectionId;
  final String trainNumber;
  final String trainName;
  final List<CoachModel> coaches;

  const CoachListModel({
    required this.inspectionId,
    required this.trainNumber,
    required this.trainName,
    required this.coaches,
  });

  factory CoachListModel.fromJson(Map<String, dynamic> json) {
    return CoachListModel(
      inspectionId: json['inspection_id'] as String,
      trainNumber: json['train_number'] as String,
      trainName: json['train_name'] as String,
      coaches: (json['coaches'] as List<dynamic>)
          .map((e) => CoachModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CoachModel {
  final String coachId;
  final int inspectionSequence;
  final String coachNumber;
  final String coachType;
  final String status;
  final String leftSide;
  final String rightSide;
  final double confidence;
  final int tankCount;
  final int defectCount;

  const CoachModel({
    required this.coachId,
    required this.inspectionSequence,
    required this.coachNumber,
    required this.coachType,
    required this.status,
    required this.leftSide,
    required this.rightSide,
    required this.confidence,
    required this.tankCount,
    required this.defectCount,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      coachId: json['coach_id'] as String,
      inspectionSequence: json['inspection_sequence'] as int,
      coachNumber: json['coach_number'] as String,
      coachType: json['coach_type'] as String,
      status: json['status'] as String,
      leftSide: json['left_side'] as String,
      rightSide: json['right_side'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      tankCount: json['tank_count'] as int,
      defectCount: json['defect_count'] as int,
    );
  }
}