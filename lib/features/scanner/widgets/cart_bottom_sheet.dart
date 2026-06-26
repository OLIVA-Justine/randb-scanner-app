import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../providers/scanner_provider.dart';
import 'cart_item_tile.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (_, provider, __) {
        final expanded = provider.isCartExpanded;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXl),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ──────────────────────────────────
              GestureDetector(
                onTap: provider.toggleCartExpanded,
                onVerticalDragEnd: (d) {
                  if (d.primaryVelocity != null) {
                    if (d.primaryVelocity! < -200) provider.setCartExpanded(true);
                    if (d.primaryVelocity! > 200) provider.setCartExpanded(false);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Cart header ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md, 0, AppSizes.md, AppSizes.sm,
                ),
                child: Row(
                  children: [
                    // Cart icon + label
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 18,
                            color: provider.isEmpty
                                ? AppColors.textHint
                                : AppColors.primary,
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Flexible(
                            child: Text(
                              provider.isEmpty
                                  ? 'Cart is empty'
                                  : provider.cartSummaryLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: provider.isEmpty
                                    ? AppColors.textHint
                                    : AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Clear button
                    if (!provider.isEmpty)
                      GestureDetector(
                        onTap: () => _confirmClear(context, provider),
                        child: Text(
                          'Clear',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    // Expand chevron
                    const SizedBox(width: AppSizes.sm),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              // ── Expanded cart items ──────────────────────────
              if (expanded && !provider.isEmpty) ...[
                const Divider(height: 1, color: AppColors.divider),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.40,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.cart.length,
                    itemBuilder: (_, i) {
                      final item = provider.cart[i];
                      return CartItemTile(
                        item: item,
                        onIncrement: () =>
                            provider.increment(item.product.id as int),
                        onDecrement: () =>
                            provider.decrement(item.product.id as int),
                        onRemove: () =>
                            provider.removeItem(item.product.id as int),
                      );
                    },
                  ),
                ),
              ],

              // ── Empty expanded state ─────────────────────────
              if (expanded && provider.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                  child: Text(
                    'Scan a product to add it to the cart',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textHint),
                  ),
                ),

              const SizedBox(height: AppSizes.sm),
            ],
          ),
        );
      },
    );
  }

  void _confirmClear(BuildContext context, ScannerProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXl)),
        title: Text('Clear Cart',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 16)),
        content: Text('Remove all items from the cart?',
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearCart();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            ),
            child: Text('Clear',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}