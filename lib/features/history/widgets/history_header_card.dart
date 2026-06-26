import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class HistoryHeaderCard extends StatelessWidget {
  const HistoryHeaderCard({
    super.key,
    required this.todayCount,
    required this.todayTotal,
    required this.onClearAll,
  });

  final int todayCount;
  final String todayTotal;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final dateStr = '${months[now.month - 1]} ${now.day}, ${now.year}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: title + clear button ─────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg, AppSizes.lg, AppSizes.md, AppSizes.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'History',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateStr,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onClearAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm + 2,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(
                      'Clear All',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ───────────────────────────────────────
          Divider(color: Colors.white.withOpacity(0.25), thickness: 1,
              indent: AppSizes.lg, endIndent: AppSizes.lg),

          // ── Today's summary ───────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.receipt_long_rounded,
                    value: todayCount.toString(),
                    label: 'Today\'s Orders',
                  ),
                ),
                Container(
                  width: 1, height: 36,
                  color: Colors.white.withOpacity(0.30),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.payments_outlined,
                    value: todayTotal,
                    label: 'Today\'s Total',
                  ),
                ),
              ],
            ),
          ),

          // ── Info note ─────────────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(
              AppSizes.lg, 0, AppSizes.lg, AppSizes.lg,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Colors.white70, size: 14),
                const SizedBox(width: AppSizes.xs),
                Expanded(
                  child: Text(
                    'Records are kept permanently. Long-press a transaction to delete it.',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}