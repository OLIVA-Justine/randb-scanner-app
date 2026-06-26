import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/transaction_model.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, vertical: AppSizes.sm + 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.divider),
            ),
            clipBehavior: Clip.antiAlias,
            child: product.imagePath != null &&
                    File(product.imagePath!).existsSync()
                ? Image.file(File(product.imagePath!), fit: BoxFit.cover)
                : const Icon(Icons.inventory_2_outlined,
                    size: 22, color: AppColors.textHint),
          ),
          const SizedBox(width: AppSizes.sm),

          // Name + barcode
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.barcode,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Subtotal
          Text(
            item.formattedSubtotal,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSizes.sm),

          // Qty controls
          Row(
            children: [
              _QtyBtn(
                icon: item.quantity == 1
                    ? Icons.delete_outline_rounded
                    : Icons.remove_rounded,
                color: item.quantity == 1 ? AppColors.error : AppColors.primary,
                onTap: onDecrement,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.xs + 2),
                child: Text(
                  item.quantity.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _QtyBtn(
                icon: Icons.add_rounded,
                color: AppColors.primary,
                onTap: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn(
      {required this.icon, required this.color, required this.onTap});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}