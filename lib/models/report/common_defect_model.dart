class CommonDefectModel {
  final String defectType;
  final String displayName;
  final int count;

  const CommonDefectModel({
    required this.defectType,
    required this.displayName,
    required this.count,
  });

  factory CommonDefectModel.fromJson(Map<String, dynamic> json) {
    return CommonDefectModel(
      defectType: json['defect_type'],
      displayName: json['display_name'],
      count: json['count'],
    );
  }
}