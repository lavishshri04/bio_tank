class RecentActivityModel {
  final List<ActivityItem> activities;

  const RecentActivityModel({
    required this.activities,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ActivityItem.fromJson(e))
          .toList(),
    );
  }
}

class ActivityItem {
  final String inspectionId;
  final String trainNumber;
  final String pitLine;
  final String status;
  final DateTime timestamp;

  const ActivityItem({
    required this.inspectionId,
    required this.trainNumber,
    required this.pitLine,
    required this.status,
    required this.timestamp,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      inspectionId: json['inspection_id'] as String,
      trainNumber: json['train_number'] as String,
      pitLine: json['pit_line'] as String,
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}