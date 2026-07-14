import 'inspection_model.dart';

class InspectionListModel {
  final int count;
  final String? next;
  final String? previous;
  final List<InspectionModel> results;

  const InspectionListModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory InspectionListModel.fromJson(Map<String, dynamic> json) {
    return InspectionListModel(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => InspectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}