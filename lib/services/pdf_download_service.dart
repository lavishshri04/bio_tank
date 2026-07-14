import '../api/api_client.dart';
import '../api/endpoints.dart';

enum ReportType {
  daily,
  weekly,
  monthly,
}

class PdfDownloadService {
  PdfDownloadService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<void> downloadReport({
    required ReportType reportType,
    required String savePath,
  }) async {
    await _apiClient.download(
      ApiEndpoints.exportReport,
      savePath,
      queryParameters: {
        'type': reportType.name,
      },
    );
  }
}