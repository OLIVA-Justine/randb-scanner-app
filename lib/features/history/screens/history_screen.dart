import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/transaction_model.dart';
import '../../services/database_service.dart';
import '../providers/history_provider.dart';
import '../widgets/history_header_card.dart';
import '../widgets/filter_bar.dart';
import '../widgets/date_group_header.dart';
import '../widgets/transaction_list_tile.dart';
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryProvider(database)..loadTransactions(),
      child: const _HistoryView(),
    );
  }
}
 
class _HistoryView extends StatelessWidget {
  const _HistoryView();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<HistoryProvider>(
          builder: (_, provider, __) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2.5),
              );
            }
 
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: provider.loadTransactions,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  // ── Header card ──────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSizes.screenPadding, AppSizes.md,
                          AppSizes.screenPadding, AppSizes.md),
                      child: HistoryHeaderCard(
                        todayCount: provider.todayTransactionCount,
                        todayTotal: provider.todayFormattedTotal,
                        onClearAll: () => _confirmClearAll(context, provider),
                      ),
                    ),
                  ),
 
                  // ── Section title ────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.screenPadding),
                      child: Text(
                        'Scanned Product',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),
 
                  // ── Date filter only ─────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.screenPadding),
                      child: FilterBar(
                        dateFilter: provider.dateFilter,
                        onDateFilterChanged: provider.setDateFilter,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),
 
                  // ── List or empty state ──────────────────
                  if (provider.isEmpty)
                    SliverFillRemaining(
                      child: _EmptyHistoryState(
                        hasFilters: provider.dateFilter != DateFilter.allTime,
                        onClearFilters: provider.clearFilters,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSizes.screenPadding, 0,
                          AppSizes.screenPadding, AppSizes.xxl + AppSizes.xl),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final key = provider.dateGroupKeys[i];
                            final txns = provider.groupedTransactions[key]!;
                            final groupTotal =
                                txns.fold(0.0, (s, t) => s + t.totalAmount);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DateGroupHeader(
                                  label: key,
                                  count: txns.length,
                                  groupTotal:
                                      '₱${groupTotal.toStringAsFixed(2)}',
                                ),
                                ...txns.map((txn) => TransactionListTile(
                                      transaction: txn,
                                      onTap: () => _openDetail(context, txn),
                                      onLongPress: () =>
                                          _confirmDelete(context, provider, txn),
                                    )),
                              ],
                            );
                          },
                          childCount: provider.dateGroupKeys.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
 
  void _openDetail(BuildContext context, TransactionModel txn) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => TransactionDetailScreen(transaction: txn)),
    );
  }
 
  Future<void> _confirmDelete(
      BuildContext context, HistoryProvider provider, TransactionModel txn) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXl)),
        title: Text('Delete Transaction',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
        content: Text('Delete ${txn.orderNumber}? This cannot be undone.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error, foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            ),
            child: Text('Delete',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      final success = await provider.deleteTransaction(txn.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success ? 'Transaction deleted.' : 'Failed to delete.',
              style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: success ? AppColors.success : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ));
      }
    }
  }
 
  Future<void> _confirmClearAll(
      BuildContext context, HistoryProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXl)),
        title: Text('Clear All History',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
        content: Text(
          'This will permanently delete all transaction records. This cannot be undone.',
          style: GoogleFonts.poppins(
              fontSize: 13, color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error, foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            ),
            child: Text('Clear All',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await provider.clearAllHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('All history cleared.',
              style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ));
      }
    }
  }
}
 
class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState(
      {required this.hasFilters, required this.onClearFilters});
  final bool hasFilters;
  final VoidCallback onClearFilters;
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters
                    ? Icons.filter_list_off_rounded
                    : Icons.receipt_long_outlined,
                size: 40,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              hasFilters ? 'No results for this period' : 'No transactions yet',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              hasFilters
                  ? 'Try a different date range'
                  : 'Scan products to create your first transaction',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
            if (hasFilters) ...[
              const SizedBox(height: AppSizes.md),
              OutlinedButton(
                onPressed: onClearFilters,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                ),
                child: Text('Show All Time',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.primary,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}