import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'dashboard/live_pitline_model.dart';
import 'package:intl/intl.dart';
import 'inspection/inspection_model.dart';


/// Overall severity used across chips, cards and coach health indicators.
enum Severity { clean, warning, critical }

extension SeverityX on Severity {
  Color get color {
    switch (this) {
      case Severity.clean:
        return AppColors.success;
      case Severity.warning:
        return AppColors.warning;
      case Severity.critical:
        return AppColors.warning;
    }
  }

  Color get tint {
    switch (this) {
      case Severity.clean:
        return AppColors.successTint;
      case Severity.warning:
        return AppColors.warningTint;
      case Severity.critical:
        return AppColors.criticalTint;
    }
  }

  String get label {
    switch (this) {
      case Severity.clean:
        return 'Clean';
      case Severity.warning:
        return 'Defect';
      case Severity.critical:
        return 'Defect';
    }
  }
}

/// Live status of a pit line inspection shown on Home.
enum PitLineStatus { scanning, awaitingTrainNumber, mapping, completed }

extension PitLineStatusX on PitLineStatus {
  String get label {
    switch (this) {
      case PitLineStatus.scanning:
        return 'Scanning';
      case PitLineStatus.awaitingTrainNumber:
        return 'Awaiting Train Number';
      case PitLineStatus.mapping:
        return 'Mapping';
      case PitLineStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case PitLineStatus.scanning:
        return AppColors.primary;
      case PitLineStatus.awaitingTrainNumber:
        return AppColors.warning;
      case PitLineStatus.mapping:
        return AppColors.primary;
      case PitLineStatus.completed:
        return AppColors.success;
    }
  }

  Color get tint {
    switch (this) {
      case PitLineStatus.scanning:
        return AppColors.primaryTint;
      case PitLineStatus.awaitingTrainNumber:
        return AppColors.warningTint;
      case PitLineStatus.mapping:
        return AppColors.primaryTint;
      case PitLineStatus.completed:
        return AppColors.successTint;
    }
  }

  IconData get icon {
    switch (this) {
      case PitLineStatus.scanning:
        return Icons.radar_rounded;
      case PitLineStatus.awaitingTrainNumber:
        return Icons.pending_actions_rounded;
      case PitLineStatus.mapping:
        return Icons.map_rounded;
      case PitLineStatus.completed:
        return Icons.check_circle_rounded;
    }
  }
}

enum InspectionHistoryStatus { pending, completed }

extension InspectionHistoryStatusX on InspectionHistoryStatus {
  String get label => this == InspectionHistoryStatus.pending ? 'Pending' : 'Completed';
  Color get color =>
      this == InspectionHistoryStatus.pending ? AppColors.warning : AppColors.success;
  Color get tint =>
      this == InspectionHistoryStatus.pending ? AppColors.warningTint : AppColors.successTint;
}

class IssueTally {
  final int missingPipe;
  final int loosePipe;
  final int dirtyTank;

  const IssueTally({
    this.missingPipe = 0,
    this.loosePipe = 0,
    this.dirtyTank = 0,
  });

  int get total => missingPipe + loosePipe + dirtyTank;
}

class PitLineInspection {
  final String pitLineNo;
  final PitLineStatus status;
  final String? trainNumber;
  final String? trainName;
  final TimeOfDay startTime;
  final int coachesDetected;
  final int coachesTotal;
  final int issueCount;
  final String inspectionId;
  final int durationMinutes;
  final IssueTally issueTally;

  const PitLineInspection({
    required this.pitLineNo,
    required this.status,
    this.trainNumber,
    this.trainName,
    required this.startTime,
    required this.coachesDetected,
    required this.coachesTotal,
    required this.issueCount,
    required this.inspectionId,
    required this.durationMinutes,
    this.issueTally = const IssueTally(),
  });
factory PitLineInspection.fromApi(LivePitLine api) {
  return PitLineInspection(
    pitLineNo: api.pitLine,

    status: switch (api.status) {
      'PENDING' => PitLineStatus.scanning,
      'PROCESSING' => PitLineStatus.mapping,
      'COMPLETED' => PitLineStatus.completed,
      'FAILED' => PitLineStatus.scanning,
      _ => PitLineStatus.scanning,
    },

    trainNumber: api.trainNumber,
    trainName: null,

    startTime: TimeOfDay.fromDateTime(
      DateTime.parse(api.startedAt).toLocal(),
    ),

    coachesDetected: api.inspectedCoaches,
    coachesTotal: api.totalCoaches,
    issueCount: api.defects,

    // Backend doesn't send these yet
    inspectionId: '',
    durationMinutes: 0,
  );
}
}

class PipeFinding {
  final String label;
  final Severity severity;
  final String finding;
  final int confidence;

  const PipeFinding({
    required this.label,
    required this.severity,
    required this.finding,
    required this.confidence,
  });
}

class CoachRecord {
  final String coachNumber;
  final String coachType;
  final Severity severity;
  final Severity leftSide;
  final Severity rightSide;
  final int confidence;
  final List<PipeFinding> findings;
  final String aiRemarks;
  final String recommendedMaintenance;

  const CoachRecord({
    required this.coachNumber,
    required this.coachType,
    required this.severity,
    required this.leftSide,
    required this.rightSide,
    required this.confidence,
    this.findings = const [],
    this.aiRemarks = '',
    this.recommendedMaintenance = '',
  });
}

class InspectionHistoryItem {
  final String inspectionId;
  final String trainNumber;
  final String trainName;
  final String date;
  final String pitLine;
  final InspectionHistoryStatus status;
  final int issueCount;

  const InspectionHistoryItem({
    required this.inspectionId,
    required this.trainNumber,
    required this.trainName,
    required this.date,
    required this.pitLine,
    required this.status,
    required this.issueCount,
  });

  factory InspectionHistoryItem.fromApi(InspectionModel api) {
    return InspectionHistoryItem(
      inspectionId: api.inspectionId,
      trainNumber: api.trainNumber,
      trainName: api.trainName,
      date: DateFormat('dd MMM yyyy, hh:mm a')
          .format(api.inspectionTime.toLocal()),
      pitLine: api.pitLine,
      issueCount: api.issueCount,
      status: api.status == 'COMPLETED'
          ? InspectionHistoryStatus.completed
          : InspectionHistoryStatus.pending,
    );
  }
}

class ActivityEvent {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const ActivityEvent({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}
