class DashboardSummaryModel {
  final TodaySummary today;

  const DashboardSummaryModel({
    required this.today,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      today: TodaySummary.fromJson(json['today']),
    );
  }
}

class TodaySummary {
  final int trainsInspected;
  final int bioTanksInspected;
  final int defectsFound;
  final int completedInspections;

  const TodaySummary({
    required this.trainsInspected,
    required this.bioTanksInspected,
    required this.defectsFound,
    required this.completedInspections,
  });

  factory TodaySummary.fromJson(Map<String, dynamic> json) {
    return TodaySummary(
      trainsInspected: json['trains_inspected'],
      bioTanksInspected: json['bio_tanks_inspected'],
      defectsFound: json['defects_found'],
      completedInspections: json['completed_inspections'],
    );
  }
}