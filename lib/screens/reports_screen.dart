import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../utils/pdf_export.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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
            const Row(
              children: [
                Expanded(child: _SummaryCard(label: 'Trains Inspected', value: '9', icon: Icons.train_rounded, color: AppColors.primary)),
                SizedBox(width: AppSpacing.md),
                Expanded(child: _SummaryCard(  label: 'Defects Found',  value: '21',  icon: Icons.report_problem_rounded,  color: AppColors.warning,)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Row(
              children: [
                Expanded(  child: _SummaryCard(    label: 'Bio Tanks Inspected',    value: '72',    icon: Icons.plumbing_rounded,    color: AppColors.primary,  ),),
                SizedBox(width: AppSpacing.md),
                Expanded(child: _SummaryCard(label: 'Completed', value: '6', icon: Icons.check_circle_rounded, color: AppColors.success)),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Weekly Summary'),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: Column(
                children: [
                  _RowStat(label: 'Trains Inspected', value: '58'),
                  Divider(height: 20),
                  _RowStat(label: 'Total Defects', value: '146'),
                  Divider(height: 20),
                 _RowStat(label: 'Coaches Inspected', value: '232'),
                  Divider(height: 20),
                  _RowStat(label: 'Bio Tanks Inspected', value: '928'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Monthly Summary'),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: Column(
                children: [
                  _RowStat(label: 'Trains Inspected', value: '241'),
                  Divider(height: 20),
                  _RowStat(label: 'Total Defects', value: '612'),
                  Divider(height: 20),
                  _RowStat(label: 'Coaches Inspected', value: '964'),
                  Divider(height: 20),
                  _RowStat(label: 'Bio Tanks Inspected', value: '3856'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            
            const SectionHeader(title: 'Most Common Defects'),
            
            const SizedBox(height: AppSpacing.md),
            
            const AppCard(
              child: Column(
                children: [
                  _RowStat(
                    label: 'Pipe Not Connected',
                    value: '42',
                  ),
                  Divider(height: 20),
                  _RowStat(
                    label: 'Pipe Support Absent',
                    value: '31',
                  ),
                  Divider(height: 20),
                  _RowStat(
                    label: 'Surface Not Clean',
                    value: '18',
                  ),
                ],
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

