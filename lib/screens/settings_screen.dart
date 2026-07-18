import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoRefresh = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: kScreenPadding,
          children: [
            const SectionHeader(title: 'System Status'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text('All systems operational',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                      Text('Updated 1 min ago',
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                  const Divider(height: 28),
                  const _StatusLine(label: 'AI Inference Engine', value: 'Online', good: true),
                  const SizedBox(height: 12),
                  const _StatusLine(label: 'Camera Network', value: 'ofline', good: true),
                  const SizedBox(height: 12),
                  const _StatusLine(label: 'Backend Connection', value: 'moke data', good: true),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'Preferences'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _SwitchTile(
                    icon: Icons.sync_rounded,
                    label: 'Auto Refresh',
                    subtitle: 'Refresh inspection status automatically',
                    value: _autoRefresh,
                    onChanged: (v) => setState(() => _autoRefresh = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const SectionHeader(title: 'About'),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _NavTile(
                    icon: Icons.info_outline_rounded,
                    label: 'About Application',
                    onTap: () => _showInfoSheet(
                      context,
                      'About Application',
                      'The AI Railway Bio-Toilet Inspection System uses computer vision '
                          'to inspect bio-toilet discharge pipes and tanks on train coaches '
                          'as they pass through maintenance pit lines, flagging missing, '
                          'loose, or dirty components for rapid manual verification.',
                    ),
                  ),
                  const Divider(height: 1, indent: 52),
                  _NavTile(
                    icon: Icons.support_agent_rounded,
                    label: 'Technical Support',
                    onTap: () => _showInfoSheet(
                      context,
                      'Support',
                      'For technical assistance, please contact the system administrator or the project development team.',
                    ),
                  ),
                  const Divider(height: 1, indent: 52),
                  const _NavTile(
                    icon: Icons.description_outlined,
                    label: 'App Version',
                    trailing: 'v1.0.0 Prototype',
                    onTap: null,
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'AI Railway Bio-Toilet Inspection System\nVersion 1.0.0 Prototype',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context, String title, String body) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final String label;
  final String value;
  final bool good;
  const _StatusLine({required this.label, required this.value, required this.good});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        StatusChip(
          label: value,
          color: good ? AppColors.success : AppColors.critical,
          background: good ? AppColors.successTint : AppColors.criticalTint,
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback? onTap;

  const _NavTile({required this.icon, required this.label, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: trailing != null
          ? Text(trailing!, style: Theme.of(context).textTheme.bodyMedium)
          : (onTap != null
              ? const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary)
              : null),
    );
  }
}
