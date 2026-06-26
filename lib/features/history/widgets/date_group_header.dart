import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class DateGroupHeader extends StatelessWidget {
  const DateGroupHeader({
    super.key,
    required this.label,
    required this.count,
    required this.groupTotal,
  });

  final String label;
  final int count;
  final String groupTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.md,
        bottom: AppSizes.sm,
      ),
      child: Row(
        children: [
          // Left line
          Expanded(
            child: Divider(color: AppColors.divider, thickness: 1),
          ),
          const SizedBox(width: AppSizes.sm),

          // Label chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm + 2,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  '$count order${count != 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  groupTotal,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),

          // Right line
          Expanded(
            child: Divider(color: AppColors.divider, thickness: 1),
          ),
        ],
      ),
    );
  }
}