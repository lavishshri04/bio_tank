class ApiEndpoints {
  ApiEndpoints._();

  /// Local backend
  static const baseUrl = "http://192.168.1.8:8000/api/v1";
  // Dashboard
  static const String dashboardSummary = '/dashboard/summary/';
  static const String dashboardStatus = '/dashboard/status/';
  static const String dashboardLivePitlines =
      '/dashboard/live-pitlines/';
  static const String dashboardRecentActivity =
      '/dashboard/recent-activity/';
  static const String dashboardTrainMapping =
      '/dashboard/train-mapping/';

  // Inspections
  static const String inspections = '/inspections/';
  static const String inspectionDetail = '/inspection/';
  static const String fetchTrain = '/inspections/';
  
  // Coach
  static const String coachList = '/inspection/';
  static const String coachDetail = '/inspection/';

  // Reports
  static const String reportsDashboard =
      '/reports/dashboard/';
  static const String commonDefects =
      '/reports/common-defects/';
  static const String exportReport =
      '/reports/export/';

  //setting
  static const String settings = '/settings/';
}