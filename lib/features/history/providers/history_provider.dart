import 'package:flutter/foundation.dart';
import '../../../models/transaction_model.dart';
import '../../services/database_service.dart';

enum DateFilter { today, yesterday, last7Days, last30Days, allTime }

class HistoryProvider extends ChangeNotifier {
  final AppDatabase _db;
  HistoryProvider(this._db);

  List<TransactionModel> _all = [];
  List<TransactionModel> _filtered = [];
  bool _isLoading = false;
  String? _error;
  DateFilter _dateFilter = DateFilter.allTime;

  bool get isLoading => _isLoading;
  String? get error => _error;
  DateFilter get dateFilter => _dateFilter;
  bool get isEmpty => _filtered.isEmpty && !_isLoading;

  int get todayTransactionCount {
    final now = DateTime.now();
    return _all.where((t) =>
        t.timestamp.year == now.year &&
        t.timestamp.month == now.month &&
        t.timestamp.day == now.day).length;
  }

  double get todayTotalAmount {
    final now = DateTime.now();
    return _all
        .where((t) =>
            t.timestamp.year == now.year &&
            t.timestamp.month == now.month &&
            t.timestamp.day == now.day)
        .fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  String get todayFormattedTotal => '₱${todayTotalAmount.toStringAsFixed(2)}';

  Map<String, List<TransactionModel>> get groupedTransactions {
    final groups = <String, List<TransactionModel>>{};
    for (final txn in _filtered) {
      final label = _dateLabel(txn.timestamp);
      groups.putIfAbsent(label, () => []).add(txn);
    }
    return groups;
  }

  List<String> get dateGroupKeys {
    final keys = groupedTransactions.keys.toList();
    keys.sort((a, b) {
      final aDate = groupedTransactions[a]!.first.timestamp;
      final bDate = groupedTransactions[b]!.first.timestamp;
      return bDate.compareTo(aDate);
    });
    return keys;
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _db.getAllTransactions();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load transactions.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDateFilter(DateFilter filter) {
    _dateFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _dateFilter = DateFilter.allTime;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<TransactionModel>.from(_all);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_dateFilter) {
      case DateFilter.today:
        result = result.where((t) => _isSameDay(t.timestamp, today)).toList();
        break;
      case DateFilter.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        result = result.where((t) => _isSameDay(t.timestamp, yesterday)).toList();
        break;
      case DateFilter.last7Days:
        final cutoff = today.subtract(const Duration(days: 7));
        result = result.where((t) => t.timestamp.isAfter(cutoff)).toList();
        break;
      case DateFilter.last30Days:
        final cutoff = today.subtract(const Duration(days: 30));
        result = result.where((t) => t.timestamp.isAfter(cutoff)).toList();
        break;
      case DateFilter.allTime:
        break;
    }
    _filtered = result;
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      await _db.deleteTransaction(id);
      _all.removeWhere((t) => t.id == id);
      _applyFilters();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAllHistory() async {
    try {
      await _db.clearAllTransactions();
      _all.clear();
      _filtered.clear();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dtDay = DateTime(dt.year, dt.month, dt.day);
    if (dtDay == today) return 'Today';
    if (dtDay == yesterday) return 'Yesterday';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String get dateFilterLabel {
    switch (_dateFilter) {
      case DateFilter.today: return 'Today';
      case DateFilter.yesterday: return 'Yesterday';
      case DateFilter.last7Days: return 'Last 7 Days';
      case DateFilter.last30Days: return 'Last 30 Days';
      case DateFilter.allTime: return 'All Time';
    }
  }
}