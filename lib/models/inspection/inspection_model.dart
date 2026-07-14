class InspectionModel {
  final String inspectionId;
  final String trainNumber;
  final String trainName;
  final DateTime inspectionTime;
  final String pitLine;
  final String status;
  final int issueCount;

  const InspectionModel({
    required this.inspectionId,
    required this.trainNumber,
    required this.trainName,
    required this.inspectionTime,
    required this.pitLine,
    required this.status,
    required this.issueCount,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      inspectionId: json['inspection_id'] as String,
      trainNumber: json['train_number'] as String,
      trainName: json['train_name'] as String,
      inspectionTime: DateTime.parse(json['inspection_time'] as String),
      pitLine: json['pit_line'] as String,
      status: json['status'] as String,
      issueCount: json['issue_count'] as int,
    );
  }
}