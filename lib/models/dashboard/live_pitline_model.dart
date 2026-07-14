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
  final String trainNumber;
  final String status;

  const LivePitLine({
    required this.pitLine,
    required this.trainNumber,
    required this.status,
  });

  factory LivePitLine.fromJson(Map<String, dynamic> json) {
    return LivePitLine(
      pitLine: json['pit_line'] as String,
      trainNumber: json['train_number'] as String,
      status: json['status'] as String,
    );
  }
}