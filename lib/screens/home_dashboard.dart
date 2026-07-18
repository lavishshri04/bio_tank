import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'inspection_details.dart';

import '../repositories/dashboard/dashboard_repository.dart';

import '../models/dashboard/dashboard_summary_model.dart';
import '../models/dashboard/dashboard_status_model.dart';
import '../models/dashboard/live_pitline_model.dart';
import '../models/dashboard/recent_activity_model.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final DashboardRepository _repository = DashboardRepository();
  DashboardSummaryModel? _dashboardSummary;
  DashboardStatusModel? _dashboardStatus;
  LivePitLinesModel? _livePitLines;
  RecentActivityModel? _recentActivity;

  Timer? _pollTimer;
  static const _pollInterval = Duration(seconds: 5);

  @override
  Widget build(BuildContext context) {
    final activeInspections =
        _livePitLines?.pitLines
            .map(PitLineInspection.fromApi)
            .toList() ??
        MockData.activeInspections;
    
    final hasActive = activeInspections.isNotEmpty;
    final activities = _recentActivity?.activities ?? [];
    final today = DateFormat('EEE, d MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Railway Bio-Toilet Inspection'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(
              child: StatusChip(
                label: 'Online',
                color: AppColors.success,
                background: AppColors.successTint,
                icon: Icons.circle,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          child: ListView(
          padding: kScreenPadding,
          children: [
            Text(today, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),

            // Operations Status Card
           AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Operations Status',
                  ),
            
                  const SizedBox(height: AppSpacing.lg),
            
                  StatusChip(
                    label: _dashboardStatus?.status == 'PROCESSING'
                        ? 'Inspection Running'
                        : 'Idle',
                    color: AppColors.success,
                    background: AppColors.successTint,
                    icon: Icons.play_circle,
                  ),
            
                  const SizedBox(height: AppSpacing.md),
            
                  Text(
                    _dashboardStatus?.message ?? 'Waiting for backend...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
           
            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Live Pit Line Activity'),
            const SizedBox(height: AppSpacing.md),

            if (!hasActive)
              const AppCard(
                child: EmptyState(
                  icon: Icons.train_rounded,
                  title: 'No Active Inspections',
                  subtitle: 'Waiting for the next train...',
                ),
              )
            else
              ...activeInspections.map(
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ActivePitLineCard(inspection: i),
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: "Today's Summary"),
            const SizedBox(height: AppSpacing.md),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                // Fixed height per card instead of an aspect ratio, so the
                // content (icon + value + label) always fits regardless of
                // screen width or text scale factor.
                mainAxisExtent: 120,
              ),
              children:  [
                StatTile(
                  label: 'Trains',
                 value: '${_dashboardSummary?.today.trainsInspected ?? MockData.todayTrains}',
                  icon: Icons.train_rounded,
                  color: AppColors.primary,
                ),
                StatTile(
                  label: 'Defects',
                  value: '${_dashboardSummary?.today.defectsFound ?? MockData.todayIssues}',
                  icon: Icons.report_problem_rounded,
                  color: AppColors.warning,
                ),
                StatTile(
                  label: 'Bio Tanks',
                 value: '${_dashboardSummary?.today.bioTanksInspected ?? MockData.todayBioTanks}',
                  icon: Icons.plumbing_rounded,
                  color: AppColors.primary,
                ),
                StatTile(
                  label: 'Completed',
                  value: '${_dashboardSummary?.today.completedInspections ?? MockData.todayCompleted}',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Recent Activity'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  
                  for (int i = 0; i < activities.length; i++) ...[
                    _ActivityTile(event: activities[i]),
                    if (i != activities.length - 1)
                      const Divider(indent: 52, height: 1),
                  ],
                ],
              ),
            ),

          ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _refreshAll();

    // Live pit-line data (e.g. a train number resolving from "Unknown" to
    // an actual number) can change on the backend at any time, so poll
    // periodically instead of only fetching once on screen load.
    _pollTimer = Timer.periodic(_pollInterval, (_) => _refreshAll());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _loadDashboardSummary(),
      _loadDashboardStatus(),
      _loadLivePitLines(),
      _loadRecentActivity(),
    ]);
  }

Future<void> _loadDashboardSummary() async {
  try {
    final summary = await _repository.getDashboardSummary();

    if (!mounted) return;
    setState(() {
      _dashboardSummary = summary;
    });

    debugPrint('Dashboard Summary Loaded');
  } catch (e) {
    debugPrint('API ERROR: $e');
  }
}

Future<void> _loadDashboardStatus() async {
  try {
    final status = await _repository.getDashboardStatus();

    if (!mounted) return;
    setState(() {
      _dashboardStatus = status;
    });

    debugPrint('Dashboard Status Loaded');
  } catch (e) {
    debugPrint('STATUS API ERROR: $e');
  }
}

Future<void> _loadLivePitLines() async {
  try {
    final pitLines = await _repository.getLivePitLines();

    if (!mounted) return;
    setState(() {
      _livePitLines = pitLines;
    });

    debugPrint('Live Pit Lines Loaded');
  } catch (e) {
    debugPrint('LIVE PITLINES API ERROR: $e');
  }
}
Future<void> _loadRecentActivity() async {
  try {
    final activity = await _repository.getRecentActivity();

    if (!mounted) return;
    setState(() {
      _recentActivity = activity;
    });

    debugPrint(
      'Recent Activities: ${activity.activities.length}',
    );
  } catch (e) {
    debugPrint('RECENT ACTIVITY API ERROR: $e');
  }
}

}

class _VDivider extends StatelessWidget {
  const _VDivider();
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.divider);
  }
}

class _OpsStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _OpsStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _ActivePitLineCard extends StatelessWidget {
  final PitLineInspection inspection;
  const _ActivePitLineCard({required this.inspection});

  @override
  Widget build(BuildContext context) {
    final status = inspection.status;
    final progress = inspection.coachesTotal == 0
        ? 0.0
        : inspection.coachesDetected / inspection.coachesTotal;

    return AppCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InspectionDetailsScreen(inspection: inspection),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: status.tint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(status.icon, size: 18, color: status.color),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    inspection.pitLineNo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              StatusChip(
                label: status.label,
                color: status.color,
                background: status.tint,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _InfoBit(
                  label: 'Train No.',
                  value: inspection.trainNumber ?? 'Unknown',
                ),
              ),
              Expanded(
                child: _InfoBit(
                  label: 'Started',
                  value: inspection.startTime.format(context),
                ),
              ),
              Expanded(
                child: _InfoBit(
                  label: 'Defects',
                  value: '${inspection.issueCount}',
                  valueColor:
                      inspection.issueCount > 0 ? AppColors.warning : AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(
                    'Inspection Progress',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),  
                Text(
                '${inspection.coachesDetected}/${inspection.coachesTotal}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppProgressBar(value: progress, color: status.color),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        InspectionDetailsScreen(inspection: inspection),
                  ),
                );
              },
              icon: Icon(
                status == PitLineStatus.completed
                    ? Icons.visibility_rounded
                    : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text( status == PitLineStatus.completed ? 'View Report': 'View Inspection',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBit extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoBit({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem event;

  const _ActivityTile({required this.event});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.successTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        event.trainNumber == null
                            ? 'Awaiting Train Number'
                            : 'Train ${event.trainNumber}',
                        style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${event.pitLine} • ${event.status}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              DateFormat('hh:mm a').format(event.timestamp.toLocal()),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      );
    }
}