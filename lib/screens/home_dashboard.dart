import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'inspection_details.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final hasActive = MockData.activeInspections.isNotEmpty;
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
        child: ListView(
          padding: kScreenPadding,
          children: [
            Text(today, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),

            // Operations Status Card
            const AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: _OpsStat(
                      label: 'Total Pit Lines',
                      value: '${MockData.totalPitLines}',
                      icon: Icons.dashboard_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  _VDivider(),
                  Expanded(
                    child: _OpsStat(
                      label: 'Active',
                      value: '${MockData.activePitLines}',
                      icon: Icons.radar_rounded,
                      color: AppColors.warning,
                    ),
                  ),
                  _VDivider(),
                  Expanded(
                    child: _OpsStat(
                      label: 'Available',
                      value: '${MockData.availablePitLines}',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
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
              ...MockData.activeInspections.map(
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ActivePitLineCard(inspection: i),
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: "Today's Summary"),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.5,
              children: const [
                StatTile(
                  label: 'Trains',
                  value: '${MockData.todayTrains}',
                  icon: Icons.train_rounded,
                  color: AppColors.primary,
                ),
                StatTile(
                  label: 'Issues',
                  value: '${MockData.todayIssues}',
                  icon: Icons.report_problem_rounded,
                  color: AppColors.warning,
                ),
                StatTile(
                  label: 'Critical',
                  value: '${MockData.todayCritical}',
                  icon: Icons.error_rounded,
                  color: AppColors.critical,
                ),
                StatTile(
                  label: 'Completed',
                  value: '${MockData.todayCompleted}',
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
                  for (int i = 0; i < MockData.recentActivity.length; i++) ...[
                    _ActivityTile(event: MockData.recentActivity[i]),
                    if (i != MockData.recentActivity.length - 1)
                      const Divider(indent: 52, height: 1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                  label: 'Train',
                  value: inspection.trainNumber ?? 'Unknown',
                ),
              ),
              Expanded(
                child: _InfoBit(
                  label: 'Start Time',
                  value: inspection.startTime.format(context),
                ),
              ),
              Expanded(
                child: _InfoBit(
                  label: 'Issues',
                  value: '${inspection.issueCount}',
                  valueColor:
                      inspection.issueCount > 0 ? AppColors.warning : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Coach Progress', style: Theme.of(context).textTheme.labelSmall),
              Text(
                '${inspection.coachesDetected}/${inspection.coachesTotal}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppProgressBar(value: progress, color: status.color),
          const SizedBox(height: AppSpacing.lg),
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
              label: Text(
                status == PitLineStatus.completed ? 'View Details' : 'Continue',
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
  final ActivityEvent event;
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
              color: event.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(event.icon, size: 16, color: event.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(event.subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Text(event.time, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
