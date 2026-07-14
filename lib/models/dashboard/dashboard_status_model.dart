class DashboardStatusModel {
  final String status;
  final String message;

  const DashboardStatusModel({
    required this.status,
    required this.message,
  });

  factory DashboardStatusModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatusModel(
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }
}