import '../../api/api_client.dart';
import '../../api/endpoints.dart';

import '../../models/coach/coach_list_model.dart';
import '../../models/coach/coach_detail_model.dart';

class CoachRepository {
  CoachRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<CoachListModel> getCoachList(
    String inspectionId, {
    String? search,
    String? filter,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    if (filter != null && filter.isNotEmpty) {
      queryParameters['filter'] = filter;
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.coachList}$inspectionId/coaches/',
      queryParameters: queryParameters,
    );

    return CoachListModel.fromJson(response.data!);
  }

  Future<CoachDetailModel> getCoachDetail(
    String inspectionId,
    String coachId,
  ) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.coachDetail}$inspectionId/coaches/$coachId/',
    );

    return CoachDetailModel.fromJson(response.data!);
  }
}