import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class CoachDetailsScreen extends StatefulWidget {
  final List<String> coachOrder;
  final int initialIndex;
  final String trainNumber;

  const CoachDetailsScreen({
    super.key,
    required this.coachOrder,
    required this.initialIndex,
    required this.trainNumber,
  });

  @override
  State<CoachDetailsScreen> createState() => _CoachDetailsScreenState();
}

class _CoachDetailsScreenState extends State<CoachDetailsScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  CoachRecord get _coach => MockData.coaches[widget.coachOrder[_index]]!;

  @override
  Widget build(BuildContext context) {
    final coach = _coach;
    final s = coach.severity;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Coach Inspection Report'),
      ),
      body: SafeArea(
        child: ListView(
          padding: kScreenPadding,
          children: [
            // Header
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coach.coachNumber, style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      '${coach.coachType} · Train ${widget.trainNumber}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const Spacer(),
                StatusChip(label: s.label, color: s.color, background: s.tint),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Large status card
            AppCard(
              color: s.tint,
              border: Border.all(color: s.color.withOpacity(0.25)),
              child: Row(
                children: [
                  Icon(
                    s == Severity.clean
                        ? Icons.verified_rounded
                        : s == Severity.warning
                            ? Icons.warning_amber_rounded
                            : Icons.error_rounded,
                    color: s.color,
                    size: 36,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s == Severity.clean
                              ? 'No Issues Detected'
                              : s == Severity.warning
                                  ? 'Minor Issues Detected'
                                  : 'Critical Issues Detected',
                          style: TextStyle(
                            color: s.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Overall AI confidence: ${coach.confidence}%',
                          style: TextStyle(color: s.color, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Inspection Information'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  _InfoRow(label: 'Coach Number', value: coach.coachNumber),
                  const Divider(height: 20),
                  _InfoRow(label: 'Coach Type', value: coach.coachType),
                  const Divider(height: 20),
                  _InfoRow(label: 'Left Side Status', value: coach.leftSide.label, valueColor: coach.leftSide.color),
                  const Divider(height: 20),
                  _InfoRow(label: 'Right Side Status', value: coach.rightSide.label, valueColor: coach.rightSide.color),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Coach Health Diagram'),
            const SizedBox(height: AppSpacing.md),
            AppCard(child: _HealthDiagram(coach: coach)),

            if (coach.findings.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'AI Findings'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    for (int i = 0; i < coach.findings.length; i++) ...[
                      _FindingTile(finding: coach.findings[i]),
                      if (i != coach.findings.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Inspection Media'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.image_rounded, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Inspection Images (AI Overlay)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 88,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) => _MediaThumb(
                        icon: Icons.camera_alt_rounded,
                        label: 'CAM ${i + 1}',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Row(
                    children: [
                      Icon(Icons.videocam_rounded, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Inspection Video', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.play_circle_fill_rounded,
                          size: 44, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Recommended Maintenance'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Text(
                coach.recommendedMaintenance.isEmpty
                    ? 'No maintenance action required.'
                    : coach.recommendedMaintenance,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'AI Remarks'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.smart_toy_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      coach.aiRemarks.isEmpty ? 'No remarks generated.' : coach.aiRemarks,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _index > 0 ? () => setState(() => _index--) : null,
                    icon: const Icon(Icons.chevron_left_rounded, size: 20),
                    label: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _index < widget.coachOrder.length - 1
                        ? () => setState(() => _index++)
                        : null,
                    icon: const Icon(Icons.chevron_right_rounded, size: 20),
                    label: const Text('Next'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Inspection report exported as PDF')),
                  );
                },
                icon: const Icon(Icons.ios_share_rounded, size: 18),
                label: const Text('Export Inspection Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
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

class _FindingTile extends StatelessWidget {
  final PipeFinding finding;
  const _FindingTile({required this.finding});

  @override
  Widget build(BuildContext context) {
    final s = finding.severity;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(finding.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(finding.finding, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Text('${finding.confidence}%',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MediaThumb extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MediaThumb({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Simple schematic coach diagram highlighting the 4 pipe points + bio tank.
class _HealthDiagram extends StatelessWidget {
  final CoachRecord coach;
  const _HealthDiagram({required this.coach});

  Severity _sevFor(String label) {
    final f = coach.findings.where((e) => e.label == label);
    if (f.isNotEmpty) return f.first.severity;
    // fallback split by side
    if (label.contains('Left')) return coach.leftSide;
    if (label.contains('Right')) return coach.rightSide;
    return coach.severity;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(Icons.directions_railway_rounded,
                    size: 56, color: AppColors.iconMuted),
              ),
              Positioned(top: 10, left: 10, child: _Dot(_sevFor('Front Left Pipe'))),
              Positioned(top: 10, right: 10, child: _Dot(_sevFor('Front Right Pipe'))),
              Positioned(bottom: 10, left: 10, child: _Dot(_sevFor('Rear Left Pipe'))),
              Positioned(bottom: 10, right: 10, child: _Dot(_sevFor('Bio Tank'))),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            _LegendItem(label: 'Front Left Pipe', severity: _sevFor('Front Left Pipe')),
            _LegendItem(label: 'Front Right Pipe', severity: _sevFor('Front Right Pipe')),
            _LegendItem(label: 'Rear Left Pipe', severity: _sevFor('Rear Left Pipe')),
            _LegendItem(label: 'Rear Right Pipe', severity: _sevFor('Rear Right Pipe')),
            _LegendItem(label: 'Bio Tank', severity: _sevFor('Bio Tank')),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Severity severity;
  const _Dot(this.severity);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: severity.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: severity.color.withOpacity(0.4), blurRadius: 6)],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Severity severity;
  const _LegendItem({required this.label, required this.severity});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: severity.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
