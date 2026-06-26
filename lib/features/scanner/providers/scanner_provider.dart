import 'package:flutter/foundation.dart';
import '../../../models/product_model.dart';
import '../../../models/transaction_model.dart';
import '../../manage/services/database_service.dart';

enum ScanStatus { idle, found, notFound, saving, saved, error }

class ScannerProvider extends ChangeNotifier {
  final AppDatabase _db;
  ScannerProvider(this._db);

  final List<CartItem> _cart = [];
  ScanStatus _status = ScanStatus.idle;
  ProductModel? _lastScanned;
  String? _errorMessage;
  bool _isCartExpanded = false;
  bool _torchOn = false;

  List<CartItem> get cart => List.unmodifiable(_cart);
  ScanStatus get status => _status;
  ProductModel? get lastScanned => _lastScanned;
  String? get errorMessage => _errorMessage;
  bool get isCartExpanded => _isCartExpanded;
  bool get torchOn => _torchOn;
  bool get isEmpty => _cart.isEmpty;
  int get totalItemCount => _cart.fold(0, (s, i) => s + i.quantity);
  double get totalAmount => _cart.fold(0.0, (s, i) => s + i.subtotal);
  String get formattedTotal => '₱${totalAmount.toStringAsFixed(2)}';
  String get cartSummaryLabel =>
      'Shopping Cart, $totalItemCount Item${totalItemCount != 1 ? 's' : ''} = ${totalAmount.toStringAsFixed(0)}';

  // ── Scan ──────────────────────────────────────────────────────────────

  Future<void> onBarcodeScanned(String barcode) async {
    if (_status == ScanStatus.saving || _status == ScanStatus.found) return;
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return;

    final product = await _db.getProductByBarcode(trimmed);
    if (product == null) {
      _status = ScanStatus.notFound;
      _errorMessage = 'No product found for barcode: $trimmed';
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      if (_status == ScanStatus.notFound) {
        _status = ScanStatus.idle;
        notifyListeners();
      }
      return;
    }

    _lastScanned = product;
    _addToCart(product);
    _status = ScanStatus.found;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));
    if (_status == ScanStatus.found) {
      _status = ScanStatus.idle;
      notifyListeners();
    }
  }

  void _addToCart(ProductModel product) {
    final i = _cart.indexWhere((c) => c.product.id == product.id);
    if (i >= 0) {
      _cart[i].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
  }

  // ── Cart controls ─────────────────────────────────────────────────────

  void increment(int productId) {
    final i = _cart.indexWhere((c) => c.product.id == productId);
    if (i >= 0) {
      _cart[i].quantity++;
      notifyListeners();
    }
  }

  void decrement(int productId) {
    final i = _cart.indexWhere((c) => c.product.id == productId);
    if (i >= 0) {
      if (_cart[i].quantity > 1) {
        _cart[i].quantity--;
      } else {
        _cart.removeAt(i);
      }
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _cart.removeWhere((c) => c.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _status = ScanStatus.idle;
    _lastScanned = null;
    _errorMessage = null;
    _isCartExpanded = false;
    notifyListeners();
  }

  void toggleCartExpanded() {
    _isCartExpanded = !_isCartExpanded;
    notifyListeners();
  }

  void setCartExpanded(bool v) {
    _isCartExpanded = v;
    notifyListeners();
  }

  void toggleTorch() {
    _torchOn = !_torchOn;
    notifyListeners();
  }

  // ── Confirm ───────────────────────────────────────────────────────────

  Future<bool> confirmTransaction() async {
    if (_cart.isEmpty) return false;
    _status = ScanStatus.saving;
    notifyListeners();
    try {
      final count = await _db.getTodayTransactionCount();
      final orderNumber = 'ORD-${(count + 1).toString().padLeft(4, '0')}';
      await _db.saveTransaction(
        orderNumber: orderNumber,
        totalAmount: totalAmount,
        totalItems: totalItemCount,
        items: List.from(_cart),
      );
      _status = ScanStatus.saved;
      notifyListeners();
      return true;
    } catch (e) {
      _status = ScanStatus.error;
      _errorMessage = 'Failed to save. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void resetAfterSave() {
    clearCart();
    _status = ScanStatus.idle;
    notifyListeners();
  }
}