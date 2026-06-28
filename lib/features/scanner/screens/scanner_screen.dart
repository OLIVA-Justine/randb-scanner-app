import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../services/database_service.dart';
import '../providers/scanner_provider.dart';
import '../widgets/cart_bottom_sheet.dart';
import '../widgets/manual_entry_dialog.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final MobileScannerController _cameraCtrl;

  @override
  void initState() {
    super.initState();
    _cameraCtrl = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _cameraCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScannerProvider(database),
      child: _ScannerView(cameraCtrl: _cameraCtrl),
    );
  }
}

class _ScannerView extends StatelessWidget {
  const _ScannerView({required this.cameraCtrl});
  final MobileScannerController cameraCtrl;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (_, provider, __) {
        final expanded = provider.isCartExpanded;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (!expanded)
                Positioned.fill(
                  child: MobileScanner(
                    controller: cameraCtrl,
                    onDetect: (capture) {
                      final barcode = capture.barcodes.firstOrNull?.rawValue;
                      if (barcode != null) provider.onBarcodeScanned(barcode);
                    },
                  ),
                ),
              if (expanded)
                Positioned.fill(child: Container(color: Colors.black87)),
              if (!expanded) const _ViewfinderOverlay(),
              Positioned(
                top: MediaQuery.of(context).padding.top + 64,
                left: AppSizes.md, right: AppSizes.md,
                child: _StatusBanner(provider: provider),
              ),
              Positioned(
                top: 0, left: 0, right: 0,
                child: _TopBar(
                  provider: provider,
                  cameraCtrl: cameraCtrl,
                  onManualEntry: () async {
                    final barcode = await ManualEntryDialog.show(context);
                    if (barcode != null && context.mounted) {
                      await provider.onBarcodeScanned(barcode);
                    }
                  },
                  onConfirm: () => _handleConfirm(context, provider),
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: const CartBottomSheet(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleConfirm(BuildContext context, ScannerProvider provider) async {
    if (provider.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cart is empty. Scan a product first.',
            style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
      ));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusXl)),
        title: Text('Confirm Transaction',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${provider.totalItemCount} item${provider.totalItemCount != 1 ? 's' : ''}',
                style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: AppSizes.xs),
            Text('Total: ${provider.formattedTotal}',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: AppSizes.sm),
            Text('Save this transaction to history?',
                style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            ),
            child: Text('Confirm', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await provider.confirmTransaction();
      if (context.mounted) {
        if (success) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusXl)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(color: AppColors.success.withOpacity(0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text('Transaction Saved!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSizes.xs),
                  Text('Order saved to history.', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                    ),
                    child: Text('New Scan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
          provider.resetAfterSave();
          if (context.mounted) Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(provider.errorMessage ?? 'Error saving.',
                style: GoogleFonts.poppins(fontSize: 13)),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          ));
        }
      }
    }
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.provider, required this.cameraCtrl, required this.onManualEntry, required this.onConfirm});
  final ScannerProvider provider;
  final MobileScannerController cameraCtrl;
  final VoidCallback onManualEntry;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
        child: Row(
          children: [
            _TopBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
            const Spacer(),
            if (!provider.isCartExpanded) ...[
              _TopBtn(
                icon: provider.torchOn ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
                onTap: () { provider.toggleTorch(); cameraCtrl.toggleTorch(); },
              ),
              const SizedBox(width: AppSizes.sm),
            ],
            _TopBtn(icon: Icons.keyboard_rounded, onTap: onManualEntry),
            const SizedBox(width: AppSizes.sm),
            _TopBtn(
              icon: Icons.check_circle_outline_rounded,
              onTap: onConfirm,
              color: provider.isEmpty ? Colors.white38 : AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBtn extends StatelessWidget {
  const _TopBtn({required this.icon, required this.onTap, this.color});
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
        child: Icon(icon, color: color ?? Colors.white, size: 20),
      ),
    );
  }
}

// ── Viewfinder Overlay ────────────────────────────────────────────────────

class _ViewfinderOverlay extends StatelessWidget {
  const _ViewfinderOverlay();

  @override
  Widget build(BuildContext context) {
    final boxSize = MediaQuery.of(context).size.width * 0.65;
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          SizedBox(
            width: boxSize, height: boxSize,
            child: CustomPaint(painter: _CornerPainter()),
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Point camera at barcode',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const len = 28.0;
    const r = 10.0;
    final w = size.width;
    final h = size.height;
    // Top-left
    canvas.drawLine(const Offset(r, 0), const Offset(len, 0), paint);
    canvas.drawLine(const Offset(0, r), const Offset(0, len), paint);
    canvas.drawArc(const Rect.fromLTWH(0, 0, r * 2, r * 2), 3.14159, 3.14159 / 2, false, paint);
    // Top-right
    canvas.drawLine(Offset(w - len, 0), Offset(w - r, 0), paint);
    canvas.drawLine(Offset(w, r), Offset(w, len), paint);
    canvas.drawArc(Rect.fromLTWH(w - r * 2, 0, r * 2, r * 2), -3.14159 / 2, 3.14159 / 2, false, paint);
    // Bottom-left
    canvas.drawLine(Offset(0, h - len), Offset(0, h - r), paint);
    canvas.drawLine(Offset(r, h), Offset(len, h), paint);
    canvas.drawArc(Rect.fromLTWH(0, h - r * 2, r * 2, r * 2), 3.14159 / 2, 3.14159 / 2, false, paint);
    // Bottom-right
    canvas.drawLine(Offset(w, h - len), Offset(w, h - r), paint);
    canvas.drawLine(Offset(w - len, h), Offset(w - r, h), paint);
    canvas.drawArc(Rect.fromLTWH(w - r * 2, h - r * 2, r * 2, r * 2), 0, 3.14159 / 2, false, paint);
  }
  @override
  bool shouldRepaint(_) => false;
}

// ── Status Banner ─────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.provider});
  final ScannerProvider provider;

  @override
  Widget build(BuildContext context) {
    final status = provider.status;
    if (status == ScanStatus.idle || status == ScanStatus.saving) return const SizedBox.shrink();

    final Color bg;
    final IconData icon;
    final String message;

    switch (status) {
      case ScanStatus.found:
        bg = AppColors.success;
        icon = Icons.check_circle_rounded;
        message = '${provider.lastScanned?.name ?? 'Product'} added to cart';
        break;
      case ScanStatus.notFound:
        bg = AppColors.error;
        icon = Icons.error_outline_rounded;
        message = provider.errorMessage ?? 'Product not found';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [BoxShadow(color: bg.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(message,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}