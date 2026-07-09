import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'coach_list.dart';

/// Screen 3. Also reused when opening a completed inspection from history,
/// in which case [startAtCompleted] renders the finished state directly.
class InspectionDetailsScreen extends StatefulWidget {
  final PitLineInspection inspection;
  final bool startAtCompleted;

  const InspectionDetailsScreen({
    super.key,
    required this.inspection,
    this.startAtCompleted = false,
  });

  @override
  State<InspectionDetailsScreen> createState() =>
      _InspectionDetailsScreenState();
}

enum _Stage { scanned, fetching, fetched, mapping, mapped }

class _InspectionDetailsScreenState extends State<InspectionDetailsScreen> {
  late _Stage _stage;
  final _trainController = TextEditingController();
  String? _fetchedTrainNumber;
  double _mappingProgress = 0;

  static const Map<String, String> _trainLookup = {
    '12951': 'Mumbai Rajdhani Express',
    '12002': 'Bhopal Shatabdi Express',
    '12622': 'Tamil Nadu Express',
  };

  @override
  void initState() {
    super.initState();
    _stage = widget.startAtCompleted
        ? _Stage.mapped
        : (widget.inspection.trainNumber != null
            ? _Stage.fetched
            : _Stage.scanned);
    if (widget.inspection.trainNumber != null) {
      _fetchedTrainNumber = widget.inspection.trainNumber;
      _trainController.text = widget.inspection.trainNumber!;
    }
  }

  @override
  void dispose() {
    _trainController.dispose();
    super.dispose();
  }

  void _fetchTrain() async {
    if (_trainController.text.trim().isEmpty) return;
    setState(() => _stage = _Stage.fetching);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _fetchedTrainNumber = _trainController.text.trim();
      _stage = _Stage.fetched;
    });
  }

  void _startMapping() async {
    setState(() {
      _stage = _Stage.mapping;
      _mappingProgress = 0;
    });
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 180));
      if (!mounted) return;
      setState(() => _mappingProgress = i / 10);
    }
    if (!mounted) return;
    setState(() => _stage = _Stage.mapped);
  }

  @override
  Widget build(BuildContext context) {
    final i = widget.inspection;
    final trainName = _trainLookup[_fetchedTrainNumber] ?? 'Regional Passenger Service';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inspection Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: kScreenPadding,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Inspection Status',
                          style: Theme.of(context).textTheme.titleMedium),
                      StatusChip(
                        label: i.status.label,
                        color: i.status.color,
                        background: i.status.tint,
                        icon: i.status.icon,
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  _KeyValueRow(label: 'Inspection ID', value: i.inspectionId),
                  const SizedBox(height: 12),
                  _KeyValueRow(label: 'Pit Line', value: i.pitLineNo),
                  const SizedBox(height: 12),
                  _KeyValueRow(
                      label: 'Inspection Time', value: i.startTime.format(context)),
                  const SizedBox(height: 12),
                  _KeyValueRow(
                      label: 'Duration', value: '${i.durationMinutes} min'),
                  const SizedBox(height: 12),
                  _KeyValueRow(
                    label: 'Detected Coaches',
                    value: '${i.coachesDetected}/${i.coachesTotal}',
                  ),
                  const SizedBox(height: 12),
                  _KeyValueRow(
                    label: 'Detected Issues',
                    value: '${i.issueCount}',
                    valueColor: i.issueCount > 0 ? AppColors.warning : AppColors.success,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Issue Summary'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  _IssueRow(
                    icon: Icons.warning_amber_rounded,
                    label: 'Missing Pipe',
                    count: i.issueTally.missingPipe,
                    color: AppColors.critical,
                  ),
                  const Divider(height: 20),
                  _IssueRow(
                    icon: Icons.link_off_rounded,
                    label: 'Loose Pipe',
                    count: i.issueTally.loosePipe,
                    color: AppColors.warning,
                  ),
                  const Divider(height: 20),
                  _IssueRow(
                    icon: Icons.water_drop_outlined,
                    label: 'Dirty Tank',
                    count: i.issueTally.dirtyTank,
                    color: AppColors.warning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ---- Train number entry / fetch / mapping flow ----
            if (_stage == _Stage.scanned || _stage == _Stage.fetching) ...[
              const SectionHeader(title: 'Train Number'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the train number manually to map detected coaches.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _trainController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'e.g. 12951',
                        prefixIcon: Icon(Icons.confirmation_number_outlined,
                            color: AppColors.textTertiary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: _stage == _Stage.fetching ? null : _fetchTrain,
                      icon: _stage == _Stage.fetching
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.search_rounded, size: 18),
                      label: Text(_stage == _Stage.fetching
                          ? 'Fetching Train Details...'
                          : 'Fetch Train Details'),
                    ),
                  ],
                ),
              ),
            ],

            if (_stage == _Stage.fetched) ...[
              const SectionHeader(title: 'Train Details'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KeyValueRow(label: 'Train Number', value: _fetchedTrainNumber ?? '-'),
                    const SizedBox(height: 12),
                    _KeyValueRow(label: 'Train Name', value: trainName),
                    const SizedBox(height: 12),
                    _KeyValueRow(label: 'Coach Count', value: '${i.coachesTotal}'),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: _startMapping,
                      icon: const Icon(Icons.map_rounded, size: 18),
                      label: const Text('Confirm & Start Mapping'),
                    ),
                  ],
                ),
              ),
            ],

            if (_stage == _Stage.mapping) ...[
              const SectionHeader(title: 'Mapping Coaches'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.autorenew_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Mapping coach ${(_mappingProgress * i.coachesTotal).round()} of ${i.coachesTotal}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppProgressBar(value: _mappingProgress),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Matching AI-detected coach order with train composition...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],

            if (_stage == _Stage.mapped) ...[
              AppCard(
                color: AppColors.successTint,
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Mapping completed successfully. Coach composition verified against train ${_fetchedTrainNumber ?? i.trainNumber ?? ''}.',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CoachListScreen(
                          trainNumber: _fetchedTrainNumber ?? i.trainNumber ?? '-',
                          trainName: trainName,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list_alt_rounded, size: 18),
                  label: const Text('View Coach List'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _KeyValueRow({required this.label, required this.value, this.valueColor});

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

class _IssueRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  const _IssueRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: count > 0 ? color : AppColors.textTertiary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: count > 0 ? color : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
