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

  // Tracks the inspection currently being opened, so the tapped card can
  // show a spinner instead of appearing unresponsive while the detail
  // request is in flight, and to prevent duplicate taps firing more than
  // one request at once.
  String? _openingId;
  
  @override
  Widget build(BuildContext context) {
    final items = (_inspectionList?.results ?? [])
        .map((e) => InspectionHistoryItem.fromApi(e))
        .where((item) {
          final matchesFilter =
              _filter == 'All' || item.status.label == _filter;

          final query = _query.trim().toLowerCase();
          final matchesQuery = query.isEmpty ||
              item.trainNumber.toLowerCase().contains(query) ||
              item.trainName.toLowerCase().contains(query);

          return matchesFilter && matchesQuery;
        })
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
                  : items.isEmpty
                      ? const Center(
                          child: EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No Inspections Found',
                            subtitle:
                                'Try a different search term or filter.',
                          ),
                        )
                      : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isOpening = _openingId == item.inspectionId;

                  return AppCard(
                      onTap: isOpening
                          ? null
                          : () async {
                        setState(() => _openingId = item.inspectionId);
                        try {
                          final detail = await _repository.getInspectionDetail(
                            item.inspectionId,
                          );
                      
                          final inspection =
                              PitLineInspection.fromInspectionDetail(detail);
                      
                          if (!context.mounted) return;
                      
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InspectionDetailsScreen(
                                inspection: inspection,
                              ),
                            ),
                          );
                          
                          // Reload inspections after returning
                          _loadInspections();
                        } catch (e) {
                          // Full error printed for diagnosis; the snackbar
                          // stays generic for the user.
                          debugPrint('INSPECTION DETAIL ERROR: $e');
                      
                          if (!context.mounted) return;
                      
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to load inspection details: $e',
                              ),
                            ),
                          );
                        } finally {
                          if (context.mounted) {
                            setState(() => _openingId = null);
                          }
                        }
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
                                  Text(
                                    item.trainNumber,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.trainName,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            isOpening
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : StatusChip(
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
                            Flexible(
                              child: _MetaChip(icon: Icons.calendar_today_rounded, label: item.date),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: _MetaChip(icon: Icons.alt_route_rounded, label: item.pitLine),
                            ),
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
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}