import '../../api/api_client.dart';
import '../../api/endpoints.dart';

import '../../models/report/report_dashboard_model.dart';
import '../../models/report/common_defect_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


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



Future<File> exportReport(String type) async {
  print('ReportRepository.exportReport() called');

  if (!Platform.isWindows) {
    throw UnsupportedError(
      'Saving to Downloads is currently implemented only for Windows.',
    );
  }

  final downloads = Directory(
    '${Platform.environment['USERPROFILE']}\\Downloads',
  );

  if (!downloads.existsSync()) {
    downloads.createSync(recursive: true);
  }

  final file = File(
    '${downloads.path}\\${type}_report.pdf',
  );

  print('Downloading to: ${file.path}');

  await _apiClient.download(
    ApiEndpoints.exportReport,
    file.path,
    queryParameters: {
      'type': type,
    },
  );

  print('Download finished.');

  return file;
}
}
