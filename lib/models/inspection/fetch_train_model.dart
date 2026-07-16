class FetchTrainModel {
  final bool success;
  final String inspectionId;
  final int coachesSynchronized;
  final bool mappingExecuted;
  final String trainNumber;
  final String trainName;

  const FetchTrainModel({
    required this.success,
    required this.inspectionId,
    required this.coachesSynchronized,
    required this.mappingExecuted,
    required this.trainNumber,
    required this.trainName,
  });

  factory FetchTrainModel.fromJson(Map<String, dynamic> json) {
    return FetchTrainModel(
      success: json['success'] as bool,
      inspectionId: json['inspection_id'] as String,
      coachesSynchronized: json['coaches_synchronized'] as int,
      mappingExecuted: json['mapping_executed'] as bool,
      trainNumber: json['train_number'] as String,
      trainName: json['train_name'] as String,
    );
  }
}