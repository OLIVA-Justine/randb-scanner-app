import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../services/database_service.dart';
import '../providers/manage_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';
import '../widgets/delete_confirm_dialog.dart';
import 'add_edit_product_screen.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageProvider(database)..loadProducts(),
      child: const _ManageView(),
    );
  }
}

class _ManageView extends StatelessWidget {
  const _ManageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.screenPadding,
                AppSizes.md,
                AppSizes.screenPadding,
                AppSizes.sm,
              ),
              child: _ManageHeader(),
            ),

            // ── Search bar ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
              ),
              child: Consumer<ManageProvider>(
                builder: (_, provider, __) => ProductSearchBar(
                  onChanged: provider.search,
                  onCleared: provider.clearSearch,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // ── Product count ──────────────────────────────────
            Consumer<ManageProvider>(
              builder: (_, provider, __) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    provider.isLoading
                        ? 'Loading...'
                        : '${provider.products.length} product${provider.products.length != 1 ? 's' : ''} found',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            // ── Product list ───────────────────────────────────
            Expanded(
              child: Consumer<ManageProvider>(
                builder: (_, provider, __) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    );
                  }

                  if (provider.isEmpty) {
                    return _EmptyProductsState(
                      hasQuery: provider.searchQuery.isNotEmpty,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.screenPadding,
                      0,
                      AppSizes.screenPadding,
                      AppSizes.xxl + AppSizes.xl,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.products.length,
                    itemBuilder: (_, index) {
                      final product = provider.products[index];
                      return ProductCard(
                        product: product,
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: provider,
                              child: AddEditProductScreen(product: product),
                            ),
                          ),
                        ),
                        onDelete: () async {
                          final confirm = await DeleteConfirmDialog.show(
                            context,
                            product.name,
                          );
                          if (confirm && context.mounted) {
                            await provider.deleteProduct(product.id!);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ── FAB: Add product ─────────────────────────────────────
      floatingActionButton: Consumer<ManageProvider>(
        builder: (_, provider, __) => FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: provider,
                child: const AddEditProductScreen(),
              ),
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          icon: const Icon(Icons.add_rounded, size: 22),
          label: Text(
            'Add Product',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────

class _ManageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Products',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Add, edit or remove products',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────────────────

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState({required this.hasQuery});
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasQuery
                    ? Icons.search_off_rounded
                    : Icons.inventory_2_outlined,
                size: 40,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              hasQuery ? 'No products found' : 'No products yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              hasQuery
                  ? 'Try a different name or barcode'
                  : 'Tap "Add Product" to get started',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}