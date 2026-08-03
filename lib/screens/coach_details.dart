import 'package:flutter/material.dart';

import '../models/coach/coach_detail_model.dart';
import '../repositories/coach/coach_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'inspection_images.dart';

class CoachDetailsScreen extends StatefulWidget {
  final String inspectionId;
  final String coachId;
  final String trainNumber;

  const CoachDetailsScreen({
    super.key,
    required this.inspectionId,
    required this.coachId,
    required this.trainNumber,
  });

  @override
  State<CoachDetailsScreen> createState() => _CoachDetailsScreenState();
}

class _CoachDetailsScreenState extends State<CoachDetailsScreen> {
  late CoachRepository _repository;

  CoachDetailModel? _coach;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = CoachRepository();
    _loadCoach();
  }

  Future<void> _loadCoach() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final coach = await _repository.getCoachDetail(
        widget.inspectionId,
        widget.coachId,
      );

      if (!mounted) return;
      setState(() {
        _coach = coach;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load coach details. Please try again.';
        _loading = false;
      });
    }
  }

  // TODO(backend): replace with the real image count from the API once
  // the inspection images endpoint is available. Derived deterministically
  // from the coach id for now so the empty state can also be previewed.
  int get _inspectionImageCount => widget.coachId.hashCode.abs() % 13;

  void _openInspectionImages(CoachDetailModel coach) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InspectionImagesScreen(
          coachNumber: coach.coach.number,
          trainNumber: widget.trainNumber,
          imageCount: _inspectionImageCount,
        ),
      ),
    );
  }

  void _openCoach(String coachId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CoachDetailsScreen(
          inspectionId: widget.inspectionId,
          coachId: coachId,
          trainNumber: widget.trainNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Coach Inspection Details'),
      ),
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: kScreenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: _loadCoach,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final coach = _coach!;
    final status = _statusStyle(coach.coach.status);
    final previousCoachId = coach.navigation.previous;
    final nextCoachId = coach.navigation.next;

    return ListView(
      padding: kScreenPadding,
      children: [
        // Header
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coach.coach.number,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${coach.coach.type} - Train ${widget.trainNumber}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            StatusChip(
              label: _displayStatus(coach.coach.status),
              color: status.color,
              background: status.tint,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Large status card
        AppCard(
          color: status.tint,
          border: Border.all(color: status.color.withValues(alpha: 0.25)),
          child: Row(
            children: [
              Icon(
                status.icon,
                color: status.color,
                size: 36,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.isClean
                          ? 'No Defects Detected'
                          : 'Defects Detected',
                      style: TextStyle(
                        color: status.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Detection confidence: ${coach.inspection.overallConfidence}%',
                      style: TextStyle(color: status.color, fontSize: 12),
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
              _InfoRow(label: 'Coach Number', value: coach.coach.number),
              const Divider(height: 20),
              _InfoRow(label: 'Coach Type', value: coach.coach.type),
              const Divider(height: 20),
              _InfoRow(
                label: 'Left Side Status',
                value: _displayStatus(coach.inspection.leftStatus),
                valueColor: _statusStyle(coach.inspection.leftStatus).color,
              ),
              const Divider(height: 20),
              _InfoRow(
                label: 'Right Side Status',
                value: _displayStatus(coach.inspection.rightStatus),
                valueColor: _statusStyle(coach.inspection.rightStatus).color,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),
        const SectionHeader(title: 'Coach Health Diagram'),
        const SizedBox(height: AppSpacing.md),
        AppCard(child: _HealthDiagram(healthDiagram: coach.healthDiagram)),

        const SizedBox(height: AppSpacing.xxl),
        const SectionHeader(title: 'Inspection Images'),
        const SizedBox(height: AppSpacing.md),
        _InspectionImagesCard(
          imageCount: _inspectionImageCount,
          onTap: () => _openInspectionImages(coach),
        ),

        if (coach.findings.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Inspection Findings'),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (int i = 0; i < coach.findings.length; i++) ...[
                  _FindingTile(finding: coach.findings[i]),
                  if (i != coach.findings.length - 1)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.xxl),
        const SectionHeader(title: 'Recommended Maintenance'),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: coach.maintenance.isEmpty
              ? Text(
                  'No maintenance action required.',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final action in coach.maintenance)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('- ', style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                action,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),

        if (coach.remarks.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: 'Remarks'),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Text(
              coach.remarks,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: previousCoachId != null
                    ? () => _openCoach(previousCoachId)
                    : null,
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                label: const Text('Previous'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    nextCoachId != null ? () => _openCoach(nextCoachId) : null,
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                label: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InspectionImagesCard extends StatelessWidget {
  final int imageCount;
  final VoidCallback onTap;

  const _InspectionImagesCard({
    required this.imageCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = imageCount > 0;

    return AppCard(
      onTap: hasImages ? onTap : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.photo_library_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inspection Images',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasImages
                      ? '$imageCount Images Available'
                      : 'No inspection images available.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (hasImages) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View Images'),
                  Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
          ],
        ],
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
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _FindingTile extends StatelessWidget {
  final Finding finding;
  const _FindingTile({required this.finding});

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(finding.title);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: status.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(finding.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(finding.description,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Text('${finding.confidence}%',
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

// ignore: unused_element
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
          Text(label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Simple schematic coach diagram highlighting the 4 pipe points + bio tank.
class _HealthDiagram extends StatelessWidget {
  final HealthDiagram healthDiagram;
  const _HealthDiagram({required this.healthDiagram});

  @override
  Widget build(BuildContext context) {
    final frontLeft = _statusStyle(healthDiagram.frontLeft);
    final frontRight = _statusStyle(healthDiagram.frontRight);
    final rearLeft = _statusStyle(healthDiagram.rearLeft);
    final rearRight = _statusStyle(healthDiagram.rearRight);
    final bioTank = _statusStyle(healthDiagram.bioTank);

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
              Positioned(top: 10, left: 10, child: _Dot(frontLeft)),
              Positioned(top: 10, right: 10, child: _Dot(frontRight)),
              Positioned(bottom: 10, left: 10, child: _Dot(rearLeft)),
              Positioned(bottom: 10, right: 10, child: _Dot(rearRight)),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(child: _Dot(bioTank)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            _LegendItem(label: 'Front Left Pipe', status: frontLeft),
            _LegendItem(label: 'Front Right Pipe', status: frontRight),
            _LegendItem(label: 'Rear Left Pipe', status: rearLeft),
            _LegendItem(label: 'Rear Right Pipe', status: rearRight),
            _LegendItem(label: 'Bio Tank', status: bioTank),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final _StatusStyle status;
  const _Dot(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: status.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: status.color.withValues(alpha: 0.4), blurRadius: 6)
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final _StatusStyle status;
  const _LegendItem({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(color: status.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _StatusStyle {
  final Color color;
  final Color tint;
  final IconData icon;
  final bool isClean;

  const _StatusStyle({
    required this.color,
    required this.tint,
    required this.icon,
    required this.isClean,
  });
}

_StatusStyle _statusStyle(String status) {
  final normalized = status.trim().toLowerCase();

  if (normalized == 'clean' ||
      normalized == 'ok' ||
      normalized == 'healthy' ||
      normalized == 'good') {
    return const _StatusStyle(
      color: AppColors.success,
      tint: AppColors.successTint,
      icon: Icons.verified_rounded,
      isClean: true,
    );
  }

  if (normalized == 'critical' ||
      normalized == 'fault' ||
      normalized == 'defective' ||
      normalized == 'defect') {
    return const _StatusStyle(
      color: AppColors.critical,
      tint: AppColors.criticalTint,
      icon: Icons.error_rounded,
      isClean: false,
    );
  }

  return const _StatusStyle(
    color: AppColors.warning,
    tint: AppColors.warningTint,
    icon: Icons.warning_amber_rounded,
    isClean: false,
  );
}

String _displayStatus(String status) {
  final trimmed = status.trim();
  return trimmed.isEmpty ? 'Unknown' : trimmed;
}