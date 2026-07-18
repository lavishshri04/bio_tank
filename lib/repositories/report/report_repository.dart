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

  final saveDir = await _resolveSaveDirectory();

  if (!saveDir.existsSync()) {
    saveDir.createSync(recursive: true);
  }

  final separator = Platform.isWindows ? '\\' : '/';
  final file = File('${saveDir.path}$separator${type}_report.pdf');

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

Future<Directory> _resolveSaveDirectory() async {
  if (Platform.isWindows) {
    return Directory('${Platform.environment['USERPROFILE']}\\Downloads');
  }

  // Android/iOS: there's no public "Downloads" folder Flutter can write to
  // without extra storage permissions, so use the app's own documents
  // directory instead. Files can still be opened/shared from here via
  // open_filex / share_plus.
  return getApplicationDocumentsDirectory();
}
}