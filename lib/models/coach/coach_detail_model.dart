class CoachDetailModel {
  final CoachInfo coach;
  final CoachInspection inspection;
  final HealthDiagram healthDiagram;
  final List<Finding> findings;
  final List<String> maintenance;
  final String remarks;
  final CoachNavigation navigation;

  const CoachDetailModel({
    required this.coach,
    required this.inspection,
    required this.healthDiagram,
    required this.findings,
    required this.maintenance,
    required this.remarks,
    required this.navigation,
  });

  factory CoachDetailModel.fromJson(Map<String, dynamic> json) {
    return CoachDetailModel(
      coach: CoachInfo.fromJson(json['coach']),
      inspection: CoachInspection.fromJson(json['inspection']),
      healthDiagram: HealthDiagram.fromJson(json['health_diagram']),
      findings: (json['findings'] as List<dynamic>)
          .map((e) => Finding.fromJson(e as Map<String, dynamic>))
          .toList(),
      maintenance: List<String>.from(json['maintenance']),
      remarks: json['remarks'] as String,
      navigation: CoachNavigation.fromJson(json['navigation']),
    );
  }
}
class CoachInfo {
  final String number;
  final String type;
  final String status;

  const CoachInfo({
    required this.number,
    required this.type,
    required this.status,
  });

  factory CoachInfo.fromJson(Map<String, dynamic> json) {
    return CoachInfo(
      number: json['number'],
      type: json['type'],
      status: json['status'],
    );
  }
}
class CoachInspection {
  final String leftStatus;
  final String rightStatus;
  final int overallConfidence;

  const CoachInspection({
    required this.leftStatus,
    required this.rightStatus,
    required this.overallConfidence,
  });

  factory CoachInspection.fromJson(Map<String, dynamic> json) {
    return CoachInspection(
      leftStatus: json['left_status'],
      rightStatus: json['right_status'],
      overallConfidence: json['overall_confidence'],
    );
  }
}
class HealthDiagram {
  final String frontLeft;
  final String frontRight;
  final String rearLeft;
  final String rearRight;
  final String bioTank;

  const HealthDiagram({
    required this.frontLeft,
    required this.frontRight,
    required this.rearLeft,
    required this.rearRight,
    required this.bioTank,
  });

  factory HealthDiagram.fromJson(Map<String, dynamic> json) {
    return HealthDiagram(
      frontLeft: json['front_left'],
      frontRight: json['front_right'],
      rearLeft: json['rear_left'],
      rearRight: json['rear_right'],
      bioTank: json['bio_tank'],
    );
  }
}
class Finding {
  final String title;
  final String description;
  final int confidence;

  const Finding({
    required this.title,
    required this.description,
    required this.confidence,
  });

  factory Finding.fromJson(Map<String, dynamic> json) {
    return Finding(
      title: json['title'],
      description: json['description'],
      confidence: json['confidence'],
    );
  }
}
class CoachNavigation {
  final String? previous;
  final String? next;

  const CoachNavigation({
    this.previous,
    this.next,
  });

  factory CoachNavigation.fromJson(Map<String, dynamic> json) {
    return CoachNavigation(
      previous: json['previous'] as String?,
      next: json['next'] as String?,
    );
  }
}