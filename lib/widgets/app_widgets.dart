import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Base rounded, soft-shadow card used everywhere in the app so every
/// screen shares the exact same surface treatment.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.soft,
        border: border,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

/// Small pill-shaped status indicator, e.g. "Scanning", "Critical".
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title with optional trailing action ("See all").
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (actionLabel != null) ...[
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact stat tile used in dashboards/reports (e.g. "Trains: 9").
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Thin colored progress bar used for coach mapping / detection progress.
class AppProgressBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        backgroundColor: AppColors.divider,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

/// Standard empty-state block (icon + title + subtitle), used on Home
/// when there are no active inspections.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Reusable enterprise-style search + filter row used on list screens.
class SearchFilterBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const SearchFilterBar({
    super.key,
    required this.hint,
    this.onChanged,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColors.textTertiary, size: 20),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final f = filters[index];
              final selected = f == selectedFilter;
              return GestureDetector(
                onTap: () => onFilterSelected(f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.card,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Standard screen scaffold padding used across tabs.
const EdgeInsets kScreenPadding = EdgeInsets.fromLTRB(20, 12, 20, 24);