import '../../api/api_client.dart';
import '../../api/endpoints.dart';

import '../../models/report/report_dashboard_model.dart';
import '../../models/report/common_defect_model.dart';

class ReportRepository {
  ReportRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<ReportDashboardModel> getDashboard() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.reportsDashboard,
    );

    return ReportDashboardModel.fromJson(response.data!);
  }

  Future<List<CommonDefectModel>> getCommonDefects() async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.commonDefects,
    );

    return response.data!
        .map((e) => CommonDefectModel.fromJson(e))
        .toList();
  }
}
