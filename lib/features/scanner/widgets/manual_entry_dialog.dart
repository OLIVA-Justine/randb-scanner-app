import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class ManualEntryDialog extends StatefulWidget {
  const ManualEntryDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const ManualEntryDialog(),
    );
  }

  @override
  State<ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends State<ManualEntryDialog> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final val = _ctrl.text.trim();
    if (val.isNotEmpty) Navigator.pop(context, val);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: const Icon(Icons.keyboard_rounded,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  'Enter Barcode',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Type the barcode number manually',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.md),

            // Input
            TextField(
              controller: _ctrl,
              focusNode: _focus,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: (_) => _submit(),
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: 2),
              decoration: InputDecoration(
                hintText: '0000000000000',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    color: AppColors.textHint,
                    letterSpacing: 2),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md, vertical: AppSizes.md),
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
                    ),
                    child: Text('Search',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}