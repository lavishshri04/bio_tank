class LivePitLinesModel {
  final List<LivePitLine> pitLines;

  const LivePitLinesModel({
    required this.pitLines,
  });

  factory LivePitLinesModel.fromJson(Map<String, dynamic> json) {
    return LivePitLinesModel(
      pitLines: (json['pit_lines'] as List<dynamic>)
          .map((e) => LivePitLine.fromJson(e))
          .toList(),
    );
  }
}
class LivePitLine {
  final String pitLine;
  final String? trainNumber;
  final String status;
  final String startedAt;
  final int defects;
  final int inspectedCoaches;
  final int totalCoaches;

  const LivePitLine({
    required this.pitLine,
    this.trainNumber,
    required this.status,
    required this.startedAt,
    required this.defects,
    required this.inspectedCoaches,
    required this.totalCoaches,
  });

  factory LivePitLine.fromJson(Map<String, dynamic> json) {
    return LivePitLine(
      pitLine: json['pit_line'] as String,
      trainNumber: json['train_number'] as String?,
      status: json['status'] as String,
      startedAt: json['started_at'] as String,
      defects: json['defects'] as int,
      inspectedCoaches: json['inspected_coaches'] as int,
      totalCoaches: json['total_coaches'] as int,
    );
  }
}