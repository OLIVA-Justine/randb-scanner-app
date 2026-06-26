import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/transaction_model.dart';


// Fixed category list as specified
const List<String> ProductCategories = [
  'All',
  'Maxglow',
  'Perfume',
  'Groceries',
  'Beauty Products',
  'Drinks/Beverages',
];

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key, required this.transaction});
  final TransactionModel transaction;

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  String _selectedCategory = 'All';

  List<ScannedItem> get _filteredItems {
    if (_selectedCategory == 'All') return widget.transaction.items;
    // Filter by matching category stored in product name context
    // Since category isn't stored per item yet, we filter by the selected
    // category matching the item's category field (added in next DB iteration)
    // For now, "All" shows everything; specific categories filter if matched
    return widget.transaction.items
        .where((item) =>
            item.productCategory != null &&
            item.productCategory!.toLowerCase() ==
                _selectedCategory.toLowerCase())
        .toList();
  }

  bool get _isFiltered => _selectedCategory != 'All';

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final filteredTotal =
        items.fold(0.0, (s, i) => s + i.subtotal);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order summary card ───────────────────────────
            _OrderSummaryCard(transaction: widget.transaction),
            const SizedBox(height: AppSizes.lg),

            // ── Scanned Products header ──────────────────────
            Row(
              children: [
                Container(
                  width: 4, height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  'Scanned Products',
                  style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  _isFiltered
                      ? '${items.length} of ${widget.transaction.items.length}'
                      : '${items.length} item${items.length != 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            // ── Category filter chips ────────────────────────
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ProductCategories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSizes.xs),
                itemBuilder: (_, i) {
                  final cat = ProductCategories[i];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md, vertical: AppSizes.xs),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusCircle),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // ── Item list ────────────────────────────────────
            if (items.isEmpty)
              _EmptyCategoryState(category: _selectedCategory)
            else ...[
              ...items.map((item) => _ItemRow(item: item)),
              const SizedBox(height: AppSizes.md),

              // ── Total breakdown ──────────────────────────
              _TotalBreakdown(
                subtotal: filteredTotal,
                isFiltered: _isFiltered,
                label: _isFiltered ? _selectedCategory : null,
              ),
            ],

            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.transaction.orderNumber,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          Text(
            widget.transaction.formattedDate,
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Order Summary Card ─────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.transaction});
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16, offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              'COMPLETED',
              style: GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.w600,
                  color: Colors.white, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            transaction.formattedTotal,
            style: GoogleFonts.poppins(
                fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Text(
            '${transaction.totalItems} item${transaction.totalItems != 1 ? 's' : ''} scanned',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
          ),
          Divider(
              color: Colors.white.withOpacity(0.25),
              thickness: 1, height: AppSizes.lg * 2),
          Row(
            children: [
              _DetailChip(
                  icon: Icons.calendar_today_rounded,
                  label: transaction.formattedDate),
              const SizedBox(width: AppSizes.sm),
              _DetailChip(
                  icon: Icons.access_time_rounded,
                  label: transaction.formattedTime),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm + 2, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}

// ── Item Row ──────────────────────────────────────────────────────────────

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final ScannedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.divider),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.imagePath != null && File(item.imagePath!).existsSync()
                ? Image.file(File(item.imagePath!), fit: BoxFit.cover)
                : const Icon(Icons.inventory_2_outlined,
                    size: 24, color: AppColors.textHint),
          ),
          const SizedBox(width: AppSizes.md),

          // Name + barcode + category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.barcode,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item.formattedPrice} × ${item.quantity}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    if (item.productCategory != null) ...[
                      const SizedBox(width: AppSizes.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Text(
                          item.productCategory!,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Subtotal
          Text(
            item.formattedSubtotal,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

// ── Empty category state ──────────────────────────────────────────────────

class _EmptyCategoryState extends StatelessWidget {
  const _EmptyCategoryState({required this.category});
  final String category;

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
          Icon(Icons.category_outlined,
              size: AppSizes.iconXl, color: AppColors.textHint),
          const SizedBox(height: AppSizes.sm),
          Text(
            'No "$category" products',
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500,
                color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'No items in this transaction match that category',
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Total Breakdown ───────────────────────────────────────────────────────

class _TotalBreakdown extends StatelessWidget {
  const _TotalBreakdown({
    required this.subtotal,
    required this.isFiltered,
    this.label,
  });
  final double subtotal;
  final bool isFiltered;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          if (isFiltered && label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: Row(
                children: [
                  Icon(Icons.filter_list_rounded,
                      size: 14, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    'Filtered by: $label',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          _TotalRow(
              label: isFiltered ? '$label Subtotal' : 'Subtotal',
              value: '₱${subtotal.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: Divider(color: AppColors.divider, thickness: 1),
          ),
          _TotalRow(
            label: isFiltered ? '$label Total' : 'Total',
            value: '₱${subtotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow(
      {required this.label, required this.value, this.isTotal = false});
  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 18 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}