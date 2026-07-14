import '../../api/api_client.dart';
import '../../api/endpoints.dart';

import '../../models/inspection/inspection_detail_model.dart';
import '../../models/inspection/inspection_list_model.dart';

class InspectionRepository {
  InspectionRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<InspectionListModel> getInspections({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };

    if (status != null) {
      queryParameters['status'] = status;
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.inspections,
      queryParameters: queryParameters,
    );

    return InspectionListModel.fromJson(response.data!);
  }
 
  Future<InspectionDetailModel> getInspectionDetail(
  String inspectionId,
) async {
  final response = await _apiClient.get<Map<String, dynamic>>(
    '${ApiEndpoints.inspectionDetail}$inspectionId/',
  );

  return InspectionDetailModel.fromJson(response.data!);
}
}