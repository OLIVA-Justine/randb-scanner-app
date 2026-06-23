import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/transaction_model.dart';
import 'recent_scan_tile.dart';

class RecentScansSection extends StatelessWidget {
  const RecentScansSection({
    super.key,
    required this.transactions,
    this.onSeeMore,
  });

  final List<TransactionModel> transactions;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent scan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Icon(
              Icons.info_outline_rounded,
              size: AppSizes.iconSm + 4,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),

        // ── Transaction list or empty state ────────────────────────
        if (transactions.isEmpty)
          _EmptyScansState()
        else
          ...List.generate(transactions.length, (index) {
            final isLast = index == transactions.length - 1;
            return RecentScanTile(
              transaction: transactions[index],
              isHighlighted: isLast,
            );
          }),

        // ── See more ───────────────────────────────────────────────
        if (transactions.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xs),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onSeeMore,
              child: Text(
                'See more',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyScansState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: AppSizes.iconXl,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'No scans yet today',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Tap the scanner button to start',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}