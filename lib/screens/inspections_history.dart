import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'inspection_details.dart';

import '../repositories/inspection/inspection_repository.dart';
import '../models/inspection/inspection_list_model.dart';

class InspectionsHistoryScreen extends StatefulWidget {
  const InspectionsHistoryScreen({super.key});

  @override
  State<InspectionsHistoryScreen> createState() =>
      _InspectionsHistoryScreenState();
}

class _InspectionsHistoryScreenState extends State<InspectionsHistoryScreen> {
  String _query = '';
  String _filter = 'All';

  final InspectionRepository _repository = InspectionRepository();
  
  InspectionListModel? _inspectionList;
  bool _isLoading = true;
  
  @override
  Widget build(BuildContext context) {
    final items = (_inspectionList?.results ?? [])
    .map((e) => InspectionHistoryItem.fromApi(e))
    .toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Inspections')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: SearchFilterBar(
                hint: 'Search train number or name',
                onChanged: (v) => setState(() => _query = v),
                filters: const ['All', 'Pending', 'Completed'],
                selectedFilter: _filter,
                onFilterSelected: (f) => setState(() => _filter = f),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return AppCard(
                    onTap: () {
                      // Synthesize a completed/pending inspection record
                      // so the shared details screen can render it.
                      final synthetic = PitLineInspection(
                        pitLineNo: item.pitLine,
                        status: item.status == InspectionHistoryStatus.completed
                            ? PitLineStatus.completed
                            : PitLineStatus.mapping,
                        trainNumber: item.trainNumber,
                        trainName: item.trainName,
                        startTime: const TimeOfDay(hour: 8, minute: 0),
                        coachesDetected: 18,
                        coachesTotal: 18,
                        issueCount: item.issueCount,
                        inspectionId:
                            'INS-${item.date.substring(0, 10).replaceAll(' ', '')}-${item.trainNumber}',
                        durationMinutes: 24,
                        issueTally: IssueTally(
                          missingPipe: (item.issueCount / 3).floor(),
                          loosePipe: (item.issueCount / 3).ceil(),
                          dirtyTank: item.issueCount -
                              (item.issueCount / 3).floor() -
                              (item.issueCount / 3).ceil() >
                              0
                              ? item.issueCount -
                                  (item.issueCount / 3).floor() -
                                  (item.issueCount / 3).ceil()
                              : 0,
                        ),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => InspectionDetailsScreen(
                            inspection: synthetic,
                            startAtCompleted:
                                item.status == InspectionHistoryStatus.completed,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.trainNumber,
                                      style: Theme.of(context).textTheme.titleMedium),
                                  Text(item.trainName,
                                      style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            StatusChip(
                              label: item.status.label,
                              color: item.status.color,
                              background: item.status.tint,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Divider(height: 1),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            _MetaChip(icon: Icons.calendar_today_rounded, label: item.date),
                            const SizedBox(width: 12),
                            _MetaChip(icon: Icons.alt_route_rounded, label: item.pitLine),
                            const Spacer(),
                            Icon(Icons.report_problem_rounded,
                                size: 15,
                                color: item.issueCount > 0
                                    ? AppColors.warning
                                    : AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text('${item.issueCount} issues',
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

@override
void initState() {
  super.initState();
  _loadInspections();
}

Future<void> _loadInspections() async {
  try {
    final inspections = await _repository.getInspections();

    setState(() {
      _inspectionList = inspections;
      _isLoading = false;
    });
  } catch (e) {
    debugPrint('INSPECTION LIST ERROR: $e');

    setState(() {
      _isLoading = false;
    });
  }
}
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
