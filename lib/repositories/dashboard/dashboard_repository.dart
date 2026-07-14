import '../../api/api_client.dart';
import '../../api/endpoints.dart';

import '../../models/dashboard/dashboard_summary_model.dart';
import '../../models/dashboard/dashboard_status_model.dart';
import '../../models/dashboard/live_pitline_model.dart';
import '../../models/dashboard/recent_activity_model.dart';
import '../../models/dashboard/train_mapping_model.dart';

class DashboardRepository {
  DashboardRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<DashboardSummaryModel> getDashboardSummary() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.dashboardSummary,
    );

    return DashboardSummaryModel.fromJson(response.data!);
  }

  Future<DashboardStatusModel> getDashboardStatus() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.dashboardStatus,
    );

    return DashboardStatusModel.fromJson(response.data!);
  }

  Future<LivePitLinesModel> getLivePitLines() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.dashboardLivePitlines,
    );

    return LivePitLinesModel.fromJson(response.data!);
  }

  Future<RecentActivityModel> getRecentActivity() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.dashboardRecentActivity,
    );

    return RecentActivityModel.fromJson(response.data!);
  }

  Future<TrainMappingModel> getTrainMapping(String inspectionId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.dashboardTrainMapping}$inspectionId/',
    );

    return TrainMappingModel.fromJson(response.data!);
  }
}