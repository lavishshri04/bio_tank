class ReportDashboardModel {
  final ReportSummary today;
  final ReportSummary weekly;
  final ReportSummary monthly;

  const ReportDashboardModel({
    required this.today,
    required this.weekly,
    required this.monthly,
  });

  factory ReportDashboardModel.fromJson(Map<String, dynamic> json) {
    return ReportDashboardModel(
      today: ReportSummary.fromJson(json['today']),
      weekly: ReportSummary.fromJson(json['weekly']),
      monthly: ReportSummary.fromJson(json['monthly']),
    );
  }
}

class ReportSummary {
  final int trainsInspected;
  final int bioTanksInspected;
  final int totalDefects;

  final int? coachesInspected;
  final int? completed;

  const ReportSummary({
    required this.trainsInspected,
    required this.bioTanksInspected,
    required this.totalDefects,
    this.coachesInspected,
    this.completed,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      trainsInspected: json['trains_inspected'],
      bioTanksInspected: json['bio_tanks_inspected'],
      totalDefects:
          json['total_defects'] ?? json['defects_found'],
      coachesInspected: json['coaches_inspected'],
      completed: json['completed'],
    );
  }
}