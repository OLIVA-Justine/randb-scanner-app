import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/transaction_model.dart';
import '../widgets/home_header_card.dart';
import '../widgets/recent_scans_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ── Mock data — will be replaced with real DB data in later modules ──
  List<TransactionModel> get _mockTransactions {
    final base = DateTime(2026, 10, 29, 7, 10);
    return List.generate(4, (i) {
      final index = 4 - i;
      return TransactionModel(
        id: 'txn-$index',
        orderNumber: 'ORD-0$index',
        timestamp: base,
        items: [
          ScannedItem(
            barcode: '123456789',
            productName: 'Sample Product',
            price: 99.99,
            quantity: 1,
          ),
        ],
        totalAmount: 99.99,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _mockTransactions;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App bar ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenPadding,
                  AppSizes.md,
                  AppSizes.screenPadding,
                  AppSizes.sm,
                ),
                child: _HomeAppBar(),
              ),
            ),

            // ── Header card ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                child: HomeHeaderCard(
                  name: 'Justine',
                  role: 'cashier',
                  scanCount: transactions.length,
                  shiftCount: 177,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.lg)),

            // ── Recent scans ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                child: RecentScansSection(
                  transactions: transactions,
                  onSeeMore: () {
                    // Will navigate to History tab in a later module
                  },
                ),
              ),
            ),

            // ── Bottom padding for nav bar ───────────────────────
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.xxl + AppSizes.lg),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top app bar row ────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App icon + title
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              'Scanner',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        // Notification bell
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: AppColors.divider),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: AppSizes.iconMd,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}