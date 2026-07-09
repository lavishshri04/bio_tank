import 'package:flutter/material.dart';
import '../models/models.dart';

/// Central mock dataset. In production this would be replaced by
/// repository calls to the AI inspection backend / MQTT stream.
class MockData {
  MockData._();

  static const int totalPitLines = 6;
  static const int activePitLines = 3;
  static const int availablePitLines = 3;

  static final List<PitLineInspection> activeInspections = [
    const PitLineInspection(
      pitLineNo: 'PL-02',
      status: PitLineStatus.scanning,
      trainNumber: null,
      startTime: TimeOfDay(hour: 9, minute: 12),
      coachesDetected: 4,
      coachesTotal: 18,
      issueCount: 2,
      inspectionId: 'INS-20260707-014',
      durationMinutes: 6,
      issueTally: IssueTally(missingPipe: 1, loosePipe: 1),
    ),
    const PitLineInspection(
      pitLineNo: 'PL-04',
      status: PitLineStatus.awaitingTrainNumber,
      trainNumber: null,
      startTime: TimeOfDay(hour: 8, minute: 46),
      coachesDetected: 18,
      coachesTotal: 18,
      issueCount: 5,
      inspectionId: 'INS-20260707-011',
      durationMinutes: 22,
      issueTally: IssueTally(missingPipe: 2, loosePipe: 2, dirtyTank: 1),
    ),
    const PitLineInspection(
      pitLineNo: 'PL-05',
      status: PitLineStatus.mapping,
      trainNumber: '12951',
      trainName: 'Mumbai Rajdhani Express',
      startTime: TimeOfDay(hour: 9, minute: 20),
      coachesDetected: 18,
      coachesTotal: 18,
      issueCount: 3,
      inspectionId: 'INS-20260707-016',
      durationMinutes: 3,
      issueTally: IssueTally(loosePipe: 2, dirtyTank: 1),
    ),
  ];

  static const int todayTrains = 9;
  static const int todayIssues = 21;
  static const int todayCritical = 4;
  static const int todayCompleted = 6;

  static final List<ActivityEvent> recentActivity = [
    const ActivityEvent(
      title: 'PL-01 inspection completed',
      subtitle: 'Train 12951 · 18 coaches mapped',
      time: '08:42 AM',
      icon: Icons.check_circle_rounded,
      color: Color(0xFF16A34A),
    ),
    const ActivityEvent(
      title: 'Critical issue flagged',
      subtitle: 'Coach B4 · Missing bio-tank pipe',
      time: '08:20 AM',
      icon: Icons.error_rounded,
      color: Color(0xFFDC2626),
    ),
    const ActivityEvent(
      title: 'PL-05 mapping started',
      subtitle: 'Train 12951 · Rajdhani Express',
      time: '09:20 AM',
      icon: Icons.map_rounded,
      color: Color(0xFF2563EB),
    ),
    const ActivityEvent(
      title: 'PL-04 scan finished',
      subtitle: 'Awaiting manual train number entry',
      time: '09:08 AM',
      icon: Icons.radar_rounded,
      color: Color(0xFF2563EB),
    ),
  ];

  static final List<InspectionHistoryItem> history = [
    const InspectionHistoryItem(
      trainNumber: '12951',
      trainName: 'Mumbai Rajdhani Express',
      date: '07 Jul 2026, 08:42 AM',
      pitLine: 'PL-01',
      status: InspectionHistoryStatus.completed,
      issueCount: 3,
    ),
    const InspectionHistoryItem(
      trainNumber: '12002',
      trainName: 'Bhopal Shatabdi Express',
      date: '07 Jul 2026, 07:15 AM',
      pitLine: 'PL-03',
      status: InspectionHistoryStatus.completed,
      issueCount: 1,
    ),
    const InspectionHistoryItem(
      trainNumber: '16032',
      trainName: 'Andaman Express',
      date: '06 Jul 2026, 09:50 PM',
      pitLine: 'PL-02',
      status: InspectionHistoryStatus.pending,
      issueCount: 6,
    ),
    const InspectionHistoryItem(
      trainNumber: '12622',
      trainName: 'Tamil Nadu Express',
      date: '06 Jul 2026, 06:30 PM',
      pitLine: 'PL-04',
      status: InspectionHistoryStatus.completed,
      issueCount: 0,
    ),
    const InspectionHistoryItem(
      trainNumber: '12910',
      trainName: 'Garib Rath Express',
      date: '06 Jul 2026, 03:12 PM',
      pitLine: 'PL-01',
      status: InspectionHistoryStatus.completed,
      issueCount: 2,
    ),
  ];

  static final List<String> coachOrder = [
    'ENGINE',
    'B1',
    'B2',
    'B3',
    'B4',
    'S1',
    'S2',
    'S3',
    'A1',
    'A2',
  ];

  static final Map<String, CoachRecord> coaches = {
    'ENGINE': const CoachRecord(
      coachNumber: 'ENGINE',
      coachType: 'Locomotive',
      severity: Severity.clean,
      leftSide: Severity.clean,
      rightSide: Severity.clean,
      confidence: 98,
      aiRemarks: 'No bio-toilet system present on locomotive.',
    ),
    'B1': const CoachRecord(
      coachNumber: 'B1',
      coachType: 'AC 3-Tier',
      severity: Severity.clean,
      leftSide: Severity.clean,
      rightSide: Severity.clean,
      confidence: 96,
      findings: [
        PipeFinding(label: 'Front Left Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 97),
        PipeFinding(label: 'Front Right Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 95),
        PipeFinding(label: 'Rear Left Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 96),
        PipeFinding(label: 'Rear Right Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 94),
        PipeFinding(label: 'Bio Tank', severity: Severity.clean, finding: 'No residue detected', confidence: 98),
      ],
      aiRemarks: 'All discharge points clear. No maintenance required.',
      recommendedMaintenance: 'None. Schedule next routine check in 15 days.',
    ),
    'B2': const CoachRecord(
      coachNumber: 'B2',
      coachType: 'AC 3-Tier',
      severity: Severity.warning,
      leftSide: Severity.warning,
      rightSide: Severity.clean,
      confidence: 91,
      findings: [
        PipeFinding(label: 'Front Left Pipe', severity: Severity.warning, finding: 'Slight misalignment detected', confidence: 89),
        PipeFinding(label: 'Front Right Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 95),
        PipeFinding(label: 'Rear Left Pipe', severity: Severity.warning, finding: 'Bracket loose, minor vibration risk', confidence: 88),
        PipeFinding(label: 'Rear Right Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 96),
        PipeFinding(label: 'Bio Tank', severity: Severity.clean, finding: 'No residue detected', confidence: 93),
      ],
      aiRemarks: 'Left-side pipe bracket shows early signs of loosening. Recommend tightening during next halt.',
      recommendedMaintenance: 'Re-tighten front-left and rear-left pipe brackets.',
    ),
    'B3': const CoachRecord(
      coachNumber: 'B3',
      coachType: 'AC 2-Tier',
      severity: Severity.critical,
      leftSide: Severity.critical,
      rightSide: Severity.warning,
      confidence: 94,
      findings: [
        PipeFinding(label: 'Front Left Pipe', severity: Severity.critical, finding: 'Pipe missing at discharge point', confidence: 96),
        PipeFinding(label: 'Front Right Pipe', severity: Severity.warning, finding: 'Corrosion visible near joint', confidence: 87),
        PipeFinding(label: 'Rear Left Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 92),
        PipeFinding(label: 'Rear Right Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 93),
        PipeFinding(label: 'Bio Tank', severity: Severity.warning, finding: 'Partial residue buildup', confidence: 90),
      ],
      aiRemarks: 'Missing discharge pipe poses contamination risk on the pit line. Immediate attention required before departure.',
      recommendedMaintenance: 'Replace front-left discharge pipe immediately. Clean bio tank residue.',
    ),
    'B4': const CoachRecord(
      coachNumber: 'B4',
      coachType: 'AC 2-Tier',
      severity: Severity.critical,
      leftSide: Severity.clean,
      rightSide: Severity.critical,
      confidence: 95,
      findings: [
        PipeFinding(label: 'Front Left Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 94),
        PipeFinding(label: 'Front Right Pipe', severity: Severity.critical, finding: 'Pipe missing at discharge point', confidence: 97),
        PipeFinding(label: 'Rear Left Pipe', severity: Severity.clean, finding: 'Secure, no leakage', confidence: 95),
        PipeFinding(label: 'Rear Right Pipe', severity: Severity.warning, finding: 'Loose coupling detected', confidence: 86),
        PipeFinding(label: 'Bio Tank', severity: Severity.clean, finding: 'No residue detected', confidence: 92),
      ],
      aiRemarks: 'Missing right-side discharge pipe flagged as critical. Coach should be held for maintenance.',
      recommendedMaintenance: 'Replace front-right discharge pipe. Verify rear-right coupling.',
    ),
    'S1': const CoachRecord(
      coachNumber: 'S1',
      coachType: 'Sleeper',
      severity: Severity.clean,
      leftSide: Severity.clean,
      rightSide: Severity.clean,
      confidence: 97,
      aiRemarks: 'No issues detected across all inspection points.',
      recommendedMaintenance: 'None.',
    ),
    'S2': const CoachRecord(
      coachNumber: 'S2',
      coachType: 'Sleeper',
      severity: Severity.warning,
      leftSide: Severity.clean,
      rightSide: Severity.warning,
      confidence: 90,
      aiRemarks: 'Minor tank residue detected on right side bio tank.',
      recommendedMaintenance: 'Schedule tank cleaning at next major halt.',
    ),
    'S3': const CoachRecord(
      coachNumber: 'S3',
      coachType: 'Sleeper',
      severity: Severity.clean,
      leftSide: Severity.clean,
      rightSide: Severity.clean,
      confidence: 96,
      aiRemarks: 'No issues detected across all inspection points.',
      recommendedMaintenance: 'None.',
    ),
    'A1': const CoachRecord(
      coachNumber: 'A1',
      coachType: 'AC First Class',
      severity: Severity.clean,
      leftSide: Severity.clean,
      rightSide: Severity.clean,
      confidence: 99,
      aiRemarks: 'All systems nominal.',
      recommendedMaintenance: 'None.',
    ),
    'A2': const CoachRecord(
      coachNumber: 'A2',
      coachType: 'AC First Class',
      severity: Severity.warning,
      leftSide: Severity.warning,
      rightSide: Severity.clean,
      confidence: 88,
      aiRemarks: 'Slight vibration detected in left pipe mount during scan.',
      recommendedMaintenance: 'Inspect left pipe mount manually.',
    ),
  };
}
