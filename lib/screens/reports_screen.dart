import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../utils/pdf_export.dart';

import '../repositories/report/report_repository.dart';
import '../models/report/report_dashboard_model.dart';
import '../models/report/common_defect_model.dart';
import '../services/pdf_download_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportRepository _repository = ReportRepository();

  ReportDashboardModel? _dashboard;
  List<CommonDefectModel> _commonDefects = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            onPressed: () async  {
              await PdfExport.generateDailyReport();
            },
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: kScreenPadding,
          children: [
            const SectionHeader(title: "Today's Summary"),
            const SizedBox(height: AppSpacing.md),
             Row(
              children: [
                Expanded(child: _SummaryCard(label: 'Trains Inspected', value: '${_dashboard?.today.trainsInspected ?? 0}', icon: Icons.train_rounded, color: AppColors.primary)),
                SizedBox(width: AppSpacing.md),
                Expanded(child: _SummaryCard(  label: 'Defects Found',  value: '${_dashboard?.today.totalDefects ?? 0}',  icon: Icons.report_problem_rounded,  color: AppColors.warning,)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
             Row(
              children: [
                Expanded(  child: _SummaryCard(    label: 'Bio Tanks Inspected',    value: '${_dashboard?.today.bioTanksInspected ?? 0}',    icon: Icons.plumbing_rounded,    color: AppColors.primary,  ),),
                SizedBox(width: AppSpacing.md),
                Expanded(child: _SummaryCard(label: 'Completed', value: '${_dashboard?.today.completed ?? 0}', icon: Icons.check_circle_rounded, color: AppColors.success)),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Weekly Summary'),
            const SizedBox(height: AppSpacing.md),
             AppCard(
              child: Column(
                children: [
                  _RowStat(label: 'Trains Inspected', value: '${_dashboard?.weekly.trainsInspected ?? 0}'),
                  Divider(height: 20),
                  _RowStat(label: 'Total Defects', value: '${_dashboard?.weekly.totalDefects ?? 0}'),
                  Divider(height: 20),
                 _RowStat(label: 'Coaches Inspected', value: '${_dashboard?.weekly.coachesInspected ?? 0}'),
                  Divider(height: 20),
                  _RowStat(label: 'Bio Tanks Inspected', value: '${_dashboard?.weekly.bioTanksInspected ?? 0}'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Monthly Summary'),
            const SizedBox(height: AppSpacing.md),
             AppCard(
              child: Column(
                children: [
                  _RowStat(label: 'Trains Inspected', value: '${_dashboard?.monthly.trainsInspected ?? 0}'),
                  Divider(height: 20),
                  _RowStat(label: 'Total Defects', value: '${_dashboard?.monthly.totalDefects ?? 0}'),
                  Divider(height: 20),
                  _RowStat(label: 'Coaches Inspected', value: '${_dashboard?.monthly.coachesInspected ?? 0}'),
                  Divider(height: 20),
                  _RowStat(label: 'Bio Tanks Inspected',value: '${_dashboard?.monthly.bioTanksInspected ?? 0}'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            
            const SectionHeader(title: 'Most Common Defects'),
            
            const SizedBox(height: AppSpacing.md),
                        
            AppCard(
              child: Column(
                children: List.generate(
                  _commonDefects.length,
                  (index) {
                    final defect = _commonDefects[index];
            
                    return Column(
                      children: [
                        _RowStat(
                          label: defect.displayName,
                          value: '${defect.count}',
                        ),
                        if (index != _commonDefects.length - 1)
                          const Divider(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            const SectionHeader(title: 'Export Reports'),
            
            const SizedBox(height: AppSpacing.md),
            
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.picture_as_pdf_rounded),
                    title: const Text('Daily Summary'),
                    trailing: const Icon(Icons.download_rounded),
                    onTap: () async {  await PdfExport.generateDailyReport();},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.date_range_rounded),
                    title: const Text('Weekly Summary'),
                    trailing: const Icon(Icons.download_rounded),
                    onTap: () async {  await PdfExport.generateDailyReport();},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.calendar_month_rounded),
                    title: const Text('Monthly Summary'),
                    trailing: const Icon(Icons.download_rounded),
                    onTap: () async {  await PdfExport.generateDailyReport();},
                  ),
                ],
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

  _loadReports();
  _loadCommonDefects();
}  
  Future<void> _loadReports() async {
  try {
    final dashboard = await _repository.getDashboard();

    setState(() {
      _dashboard = dashboard;
    });
  } catch (e) {
    debugPrint('REPORT DASHBOARD ERROR: $e');
  }
}

Future<void> _loadCommonDefects() async {
  try {
    final defects = await _repository.getCommonDefects();

    setState(() {
      _commonDefects = defects;
    });
  } catch (e) {
    debugPrint('COMMON DEFECT ERROR: $e');
  }
}
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return StatTile(label: label, value: value, icon: icon, color: color);
  }
}

class _RowStat extends StatelessWidget {
  final String label;
  final String value;
  const _RowStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
    }
}

