import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../providers/history_provider.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.dateFilter,
    required this.onDateFilterChanged,
  });

  final DateFilter dateFilter;
  final ValueChanged<DateFilter> onDateFilterChanged;

  @override
  Widget build(BuildContext context) {
    return _FilterDropdown<DateFilter>(
      value: dateFilter,
      items: const [
        DropdownMenuItem(value: DateFilter.today, child: Text('Today')),
        DropdownMenuItem(value: DateFilter.yesterday, child: Text('Yesterday')),
        DropdownMenuItem(value: DateFilter.last7Days, child: Text('Last 7 Days')),
        DropdownMenuItem(value: DateFilter.last30Days, child: Text('Last 30 Days')),
        DropdownMenuItem(value: DateFilter.allTime, child: Text('All Time')),
      ],
      onChanged: (v) { if (v != null) onDateFilterChanged(v); },
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + 2, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary, size: 18),
          style: GoogleFonts.poppins(
              fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}