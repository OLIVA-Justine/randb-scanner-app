import 'package:flutter/foundation.dart';
import '../../../models/product_model.dart';
import '../../services/database_service.dart';

// Same categories used across the app
const List<String> kManageCategories = [
  'Maxglow',
  'Perfume',
  'Groceries',
  'Beauty Products',
  'Drinks/Beverages',
];
 
class ManageProvider extends ChangeNotifier {
  final AppDatabase _db;
  ManageProvider(this._db);
 
  List<ProductModel> _products = [];
  List<ProductModel> _filtered = [];
  String _searchQuery = '';
  String? _selectedCategory; // null = All
  bool _isLoading = false;
  String? _error;
 
  List<ProductModel> get products => _filtered;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
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
 
  // ── Category filter ───────────────────────────────────────────────────
 
  void setCategory(String? category) {
    _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }
 
  void _applyFilter() {
    var result = List<ProductModel>.from(_products);
 
    // Apply category filter
    if (_selectedCategory != null) {
      result = result
          .where((p) =>
              p.category?.toLowerCase() ==
              _selectedCategory!.toLowerCase())
          .toList();
    }
 
    // Apply search filter on top
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.barcode.toLowerCase().contains(q) ||
            (p.category?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
 
    _filtered = result;
  }
 
  // ── CRUD ──────────────────────────────────────────────────────────────
 
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
