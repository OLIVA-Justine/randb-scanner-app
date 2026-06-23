import 'package:flutter/foundation.dart';
import '../../../models/product_model.dart';
import '../services/database_service.dart';

class ManageProvider extends ChangeNotifier {
  final AppDatabase _db;

  ManageProvider(this._db);

  List<ProductModel> _products = [];
  List<ProductModel> _filtered = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _filtered;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  bool get isEmpty => _filtered.isEmpty && !_isLoading;

  // ── Load ──────────────────────────────────────────────────────────────

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _db.getAllProducts();
      _applyFilter();
    } catch (e) {
      _error = 'Failed to load products.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Search ────────────────────────────────────────────────────────────

  void search(String query) {
    _searchQuery = query.trim();
    _applyFilter();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_products);
    } else {
      final q = _searchQuery.toLowerCase();
      _filtered = _products.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.barcode.toLowerCase().contains(q) ||
            (p.category?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
  }

  // ── Add ───────────────────────────────────────────────────────────────

  Future<bool> addProduct(ProductModel product) async {
    try {
      await _db.insertProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      _error = 'Failed to add product.';
      notifyListeners();
      return false;
    }
  }

  // ── Edit ──────────────────────────────────────────────────────────────

  Future<bool> updateProduct(ProductModel product) async {
    try {
      await _db.updateProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      _error = 'Failed to update product.';
      notifyListeners();
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────

  Future<bool> deleteProduct(int id) async {
    try {
      await _db.deleteProduct(id);
      await loadProducts();
      return true;
    } catch (e) {
      _error = 'Failed to delete product.';
      notifyListeners();
      return false;
    }
  }
}