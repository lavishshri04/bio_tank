class InspectionDetailModel {
  final String inspectionId;
  final String status;
  final String pitLine;
  final TrainInfo train;
  final InspectionInfo inspection;
  final DefectSummary defectSummary;
  final MappingInfo mapping;

  const InspectionDetailModel({
    required this.inspectionId,
    required this.status,
    required this.pitLine,
    required this.train,
    required this.inspection,
    required this.defectSummary,
    required this.mapping,
  });

  factory InspectionDetailModel.fromJson(Map<String, dynamic> json) {
    return InspectionDetailModel(
      inspectionId: json['inspection_id'],
      status: json['status'],
      pitLine: json['pit_line'],
      train: TrainInfo.fromJson(json['train']),
      inspection: InspectionInfo.fromJson(json['inspection']),
      defectSummary: DefectSummary.fromJson(json['defect_summary']),
      mapping: MappingInfo.fromJson(json['mapping']),
    );
  }
}
class TrainInfo {
  final String number;
  final String name;

  const TrainInfo({
    required this.number,
    required this.name,
  });

  factory TrainInfo.fromJson(Map<String, dynamic> json) {
    return TrainInfo(
      number: json['number'],
      name: json['name'],
    );
  }
}
class InspectionInfo {
  final DateTime startedAt;
  final int durationMinutes;
  final int coachesDetected;
  final int totalCoaches;
  final int totalDefects;

  const InspectionInfo({
    required this.startedAt,
    required this.durationMinutes,
    required this.coachesDetected,
    required this.totalCoaches,
    required this.totalDefects,
  });

  factory InspectionInfo.fromJson(Map<String, dynamic> json) {
    return InspectionInfo(
      startedAt: DateTime.parse(json['started_at']),
      durationMinutes: json['duration_minutes'],
      coachesDetected: json['coaches_detected'],
      totalCoaches: json['total_coaches'],
      totalDefects: json['total_defects'],
    );
  }
}
class DefectSummary {
  final int pipeNotConnected;
  final int pipeSupportAbsent;
  final int surfaceNotClean;

  const DefectSummary({
    required this.pipeNotConnected,
    required this.pipeSupportAbsent,
    required this.surfaceNotClean,
  });

  factory DefectSummary.fromJson(Map<String, dynamic> json) {
    return DefectSummary(
      pipeNotConnected: json['pipe_not_connected'],
      pipeSupportAbsent: json['pipe_support_absent'],
      surfaceNotClean: json['surface_not_clean'],
    );
  }
}
class MappingInfo {
  final bool completed;
  final String message;

  const MappingInfo({
    required this.completed,
    required this.message,
  });

  factory MappingInfo.fromJson(Map<String, dynamic> json) {
    return MappingInfo(
      completed: json['completed'],
      message: json['message'],
    );
  }
}