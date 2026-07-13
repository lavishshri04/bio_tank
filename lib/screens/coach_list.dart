import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'coach_details.dart';

class CoachListScreen extends StatefulWidget {
  final String trainNumber;
  final String trainName;

  const CoachListScreen({
    super.key,
    required this.trainNumber,
    required this.trainName,
  });

  @override
  State<CoachListScreen> createState() => _CoachListScreenState();
}

class _CoachListScreenState extends State<CoachListScreen> {
  String _query = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final order = MockData.coachOrder;

    final filtered = order.where((code) {
      final coach = MockData.coaches[code]!;
      final matchesQuery =
          _query.isEmpty || code.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = switch (_filter) {
        'Defects' =>
            coach.severity == Severity.warning ||
            coach.severity == Severity.critical,
        'Clean' => coach.severity == Severity.clean,
        _ => true,
      };
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.trainNumber} · Coach List'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.trainName,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                  SearchFilterBar(
                    hint: 'Search coach number',
                    onChanged: (v) => setState(() => _query = v),
                    filters: const ['All', 'Defects', 'Clean'],
                    selectedFilter: _filter,
                    onFilterSelected: (f) => setState(() => _filter = f),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final code = filtered[index];
                  final coach = MockData.coaches[code]!;
                  return _CoachCard(
                    coach: coach,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CoachDetailsScreen(
                            coachOrder: order,
                            initialIndex: order.indexOf(code),
                            trainNumber: widget.trainNumber,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  final CoachRecord coach;
  final VoidCallback onTap;
  const _CoachCard({required this.coach, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = coach.severity;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: s.tint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      coach.coachNumber == 'ENGINE' ? 'E' : coach.coachNumber,
                      style: TextStyle(
                        color: s.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coach.coachNumber,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        coach.coachNumber == 'ENGINE'
                            ? 'Locomotive • No Bio-Toilet'
                            : coach.coachType,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              StatusChip(
                label: coach.coachNumber == 'ENGINE' ? 'N/A' : s.label,
                color: coach.coachNumber == 'ENGINE'
                    ? Colors.grey
                    : s.color,
                background: coach.coachNumber == 'ENGINE'
                    ? Colors.grey.shade200
                    : s.tint,
              ),            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _SideBadge(label: 'Left Side', severity: coach.leftSide),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SideBadge(label: 'Right Side', severity: coach.rightSide),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Confidence', style: Theme.of(context).textTheme.labelSmall),
                  Text(
                    '${coach.confidence}%',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideBadge extends StatelessWidget {
  final String label;
  final Severity severity;
  const _SideBadge({required this.label, required this.severity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: severity.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
