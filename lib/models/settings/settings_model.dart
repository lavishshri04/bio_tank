class SettingsModel {
  final SystemStatus systemStatus;
  final Preferences preferences;
  final AboutApplication about;

  const SettingsModel({
    required this.systemStatus,
    required this.preferences,
    required this.about,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      systemStatus: SystemStatus.fromJson(json['system_status']),
      preferences: Preferences.fromJson(json['preferences']),
      about: AboutApplication.fromJson(json['about']),
    );
  }
}
class SystemStatus {
  final String overall;
  final DateTime lastUpdated;
  final List<ServiceStatus> services;

  const SystemStatus({
    required this.overall,
    required this.lastUpdated,
    required this.services,
  });

  factory SystemStatus.fromJson(Map<String, dynamic> json) {
    return SystemStatus(
      overall: json['overall'],
      lastUpdated: DateTime.parse(json['last_updated']),
      services: (json['services'] as List)
          .map((e) => ServiceStatus.fromJson(e))
          .toList(),
    );
  }
}
class ServiceStatus {
  final String name;
  final String status;

  const ServiceStatus({
    required this.name,
    required this.status,
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      name: json['name'],
      status: json['status'],
    );
  }
}
class Preferences {
  final bool autoRefresh;

  const Preferences({
    required this.autoRefresh,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      autoRefresh: json['auto_refresh'],
    );
  }
}
class AboutApplication {
  final String applicationName;
  final String version;
  final TechnicalSupport technicalSupport;

  const AboutApplication({
    required this.applicationName,
    required this.version,
    required this.technicalSupport,
  });

  factory AboutApplication.fromJson(Map<String, dynamic> json) {
    return AboutApplication(
      applicationName: json['application_name'],
      version: json['version'],
      technicalSupport:
          TechnicalSupport.fromJson(json['technical_support']),
    );
  }
}
class TechnicalSupport {
  final String email;

  const TechnicalSupport({
    required this.email,
  });

  factory TechnicalSupport.fromJson(Map<String, dynamic> json) {
    return TechnicalSupport(
      email: json['email'],
    );
  }
}