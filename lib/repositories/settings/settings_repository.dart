import '../../api/api_client.dart';
import '../../api/endpoints.dart';

import '../../models/settings/settings_model.dart';

class SettingsRepository {
  SettingsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<SettingsModel> getSettings() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.settings,
    );

    return SettingsModel.fromJson(response.data!);
  }
}