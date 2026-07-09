import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report exported as PDF')),
              );
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
                Expanded(child: _SummaryCard(label: 'Issues Found', value: '21', icon: Icons.report_problem_rounded, color: AppColors.warning)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Row(
              children: [
                Expanded(child: _SummaryCard(label: 'Critical', value: '4', icon: Icons.error_rounded, color: AppColors.critical)),
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
                  _RowStat(label: 'Total Issues', value: '146'),
                  Divider(height: 20),
                  _RowStat(label: 'Critical Issues', value: '19'),
                  Divider(height: 20),
                  _RowStat(label: 'Avg. Inspection Time', value: '24 min'),
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
                  _RowStat(label: 'Total Issues', value: '612'),
                  Divider(height: 20),
                  _RowStat(label: 'Critical Issues', value: '84'),
                  Divider(height: 20),
                  _RowStat(label: 'Resolution Rate', value: '96.4%'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Issue Distribution'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: SizedBox(
                height: 190,
                child: Row(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 34,
                          sections: [
                            PieChartSectionData(
                              value: 42,
                              color: AppColors.warning,
                              title: '',
                              radius: 42,
                            ),
                            PieChartSectionData(
                              value: 34,
                              color: AppColors.critical,
                              title: '',
                              radius: 42,
                            ),
                            PieChartSectionData(
                              value: 24,
                              color: AppColors.primary,
                              title: '',
                              radius: 42,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LegendRow(color: AppColors.warning, label: 'Loose Pipe', pct: '42%'),
                          SizedBox(height: 10),
                          _LegendRow(color: AppColors.critical, label: 'Missing Pipe', pct: '34%'),
                          SizedBox(height: 10),
                          _LegendRow(color: AppColors.primary, label: 'Dirty Tank', pct: '24%'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Weekly Trend'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                            final i = value.toInt();
                            if (i < 0 || i >= days.length) return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(days[i],
                                  style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 18),
                          FlSpot(1, 24),
                          FlSpot(2, 15),
                          FlSpot(3, 30),
                          FlSpot(4, 21),
                          FlSpot(5, 12),
                          FlSpot(6, 26),
                        ],
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withOpacity(0.08),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report exported as PDF')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                label: const Text('Export PDF'),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;
  const _LegendRow({required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        Text(pct, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
