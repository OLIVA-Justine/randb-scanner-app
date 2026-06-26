import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/transaction_model.dart';
import '../../manage/services/database_service.dart';
import '../widgets/home_header_card.dart';
import '../widgets/recent_scans_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> _recentTransactions = [];
  int _todayScanCount = 0;
  bool _isLoading = true;
 
  @override
  void initState() {
    super.initState();
    _loadData();
  }
 
  Future<void> _loadData() async {
    try {
      final all = await database.getAllTransactions();
      final count = await database.getTodayTransactionCount();
      if (mounted) {
        setState(() {
          // Show most recent 4 transactions on home
          _recentTransactions = all.take(4).toList();
          _todayScanCount = count;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _loadData,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ── App bar ────────────────────────────────────
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
 
              // ── Header card ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  child: HomeHeaderCard(
                    name: 'Justine',
                    role: 'cashier',
                    scanCount: _todayScanCount,
                    shiftCount: _recentTransactions.fold(
                        0, (s, t) => s + t.totalItems),
                  ),
                ),
              ),
 
              const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.lg)),
 
              // ── Recent scans ───────────────────────────────
              SliverToBoxAdapter(
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.xl),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.screenPadding,
                        ),
                        child: RecentScansSection(
                          transactions: _recentTransactions,
                          onSeeMore: () {
                            // Navigate to History tab — handled by MainShell
                          },
                        ),
                      ),
              ),
 
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSizes.xxl + AppSizes.lg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ── Top App Bar ────────────────────────────────────────────────────────────
 
class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(Icons.qr_code_2_rounded,
                  color: Colors.white, size: 22),
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
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Icon(Icons.notifications_none_rounded,
              size: AppSizes.iconMd, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}