import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'coach_list.dart';
import '../repositories/inspection/inspection_repository.dart';
import '../models/inspection/inspection_detail_model.dart';

/// Screen 3. Also reused when opening a completed inspection from history,
/// in which case [startAtCompleted] renders the finished state directly.
class InspectionDetailsScreen extends StatefulWidget {
  final PitLineInspection inspection;

  const InspectionDetailsScreen({
    super.key,
    required this.inspection,
  });

  @override
  State<InspectionDetailsScreen> createState() =>
      _InspectionDetailsScreenState();
}

enum _Stage { scanned, fetching, mapped }

class _InspectionDetailsScreenState extends State<InspectionDetailsScreen> {
  late _Stage _stage;
  final _trainController = TextEditingController();
  InspectionDetailModel? _detail;

final InspectionRepository _repository = InspectionRepository();

bool _loading = false;
String? _mappedTrainNumber;
String? _mappedTrainName;
int? _coachesSynchronized;


  @override
  void initState() {
    super.initState();
  
    _stage = widget.inspection.status == PitLineStatus.completed
        ? _Stage.mapped
        : _Stage.scanned;
      _loadInspectionDetail();
  }
  @override
  void dispose() {
    _trainController.dispose();
    super.dispose();
  }

Future<void> _fetchTrain() async {
  final trainNumber = _trainController.text.trim();

  if (trainNumber.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter train number'),
      ),
    );
    return;
  }

  setState(() {
    _loading = true;
  });

  try {
      final response = await _repository.fetchTrain(
        widget.inspection.inspectionId,
        trainNumber,
      );
      
      if (!mounted) return;
      
      setState(() {
        _mappedTrainNumber = response.trainNumber;
        _mappedTrainName = response.trainName;
        _coachesSynchronized = response.coachesSynchronized;
      
        _stage = _Stage.mapped;
      }
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}
Future<void> _loadInspectionDetail() async {
  try {
    final detail = await _repository.getInspectionDetail(
      widget.inspection.inspectionId,
    );

    if (!mounted) return;

    setState(() {
      _detail = detail;

      // If this is already a completed inspection,
      // populate the mapping card.
      if (widget.inspection.status == PitLineStatus.completed) {
        _mappedTrainNumber = detail.train.number;
        _mappedTrainName = detail.train.name;
        _coachesSynchronized = detail.train.coachesSynchronized;
      }
    });
  } catch (e) {
    debugPrint('Failed to load inspection detail: $e');
  }
}
 
  @override
  Widget build(BuildContext context) {
      final i = _detail != null
          ? PitLineInspection.fromInspectionDetail(_detail!)
          : widget.inspection;
      final isCompleted = i.status == PitLineStatus.completed;

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
                  _KeyValueRow(
                    label: 'Inspection ID',
                    value: i.inspectionId,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: i.inspectionId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Inspection ID copied'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
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
            if (!isCompleted &&
                (_stage == _Stage.scanned || _stage == _Stage.fetching)) ...[
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
                      onPressed: _loading ? null : _fetchTrain,
                      icon: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.search_rounded, size: 18),
                      label: Text(
                        _loading
                            ? 'Fetching Train Details...'
                            : 'Fetch Train Details',
                      ),
                    ),
                  ],
                ),
              ),
            ],          
          
            if (_stage == _Stage.mapped) ...[
              const SectionHeader(title: 'Mapping Completed'),
              const SizedBox(height: AppSpacing.md),
            
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Train mapped successfully.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 20),
            
                    _KeyValueRow(
                      label: 'Train Number',
                      value: _mappedTrainNumber ?? '-',
                    ),
            
                    const SizedBox(height: 12),
            
                    _KeyValueRow(
                      label: 'Train Name',
                      value: _mappedTrainName ?? '-',
                    ),
            
                    const SizedBox(height: 12),
            
                    _KeyValueRow(
                      label: 'Coaches Synchronized',
                      value: '${_coachesSynchronized ?? 0}',
                    ),
            
                    const SizedBox(height: AppSpacing.lg),
            
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.list_alt_rounded),
                        label: const Text('View Coach List'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoachListScreen(
                                inspectionId: widget.inspection.inspectionId,
                                trainNumber: _mappedTrainNumber ?? '',
                                trainName: _mappedTrainName ?? '',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
  final VoidCallback? onTap;
  const _KeyValueRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final valueText = Text(
      value,
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: valueColor ?? AppColors.textPrimary,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: onTap == null
              ? valueText
              : GestureDetector(onTap: onTap, child: valueText),
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