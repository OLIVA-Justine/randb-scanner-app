import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../models/product_model.dart';
import '../../../models/transaction_model.dart';

part 'database_service.g.dart';
 
// ── Tables ─────────────────────────────────────────────────────────────────
 
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get barcode => text()();
  RealColumn get price => real()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  IntColumn get quantity => integer().nullable()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
}
 
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderNumber => text()();
  RealColumn get totalAmount => real()();
  IntColumn get totalItems => integer()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get note => text().nullable()();
}
 
class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId =>
      integer().references(Transactions, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get productName => text()();
  TextColumn get productBarcode => text()();
  RealColumn get productPrice => real()();
  TextColumn get productImagePath => text().nullable()();
  TextColumn get productCategory => text().nullable()();
  IntColumn get quantity => integer()();
  RealColumn get subtotal => real()();
}
 
// ── Database ───────────────────────────────────────────────────────────────
 
@DriftDatabase(tables: [Products, Transactions, TransactionItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
 
  @override
  int get schemaVersion => 3;
 
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(transactions);
            await m.createTable(transactionItems);
          }
          if (from < 3) {
            await m.addColumn(transactionItems, transactionItems.productCategory);
          }
        },
      );
 
  // ── Products CRUD ────────────────────────────────────────────────────
 
  Future<List<ProductModel>> getAllProducts() async {
    final rows = await select(products).get();
    return rows.map(_rowToProductModel).toList();
  }
 
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    final row = await (select(products)
          ..where((t) => t.barcode.equals(barcode))
          ..limit(1))
        .getSingleOrNull();
    return row != null ? _rowToProductModel(row) : null;
  }
 
  Future<List<ProductModel>> searchProducts(String query) async {
    final rows = await (select(products)
          ..where((t) =>
              t.name.like('%$query%') | t.barcode.like('%$query%')))
        .get();
    return rows.map(_rowToProductModel).toList();
  }
 
  Future<int> insertProduct(ProductModel model) =>
      into(products).insert(_productToCompanion(model));
 
  Future<bool> updateProduct(ProductModel model) =>
      update(products).replace(_productToCompanion(model));
 
  Future<int> deleteProduct(int id) =>
      (delete(products)..where((t) => t.id.equals(id))).go();
 
  // ── Transactions ─────────────────────────────────────────────────────
 
  Future<int> saveTransaction({
    required String orderNumber,
    required double totalAmount,
    required int totalItems,
    required List<CartItem> items,
    String? note,
  }) async {
    return transaction(() async {
      final txnId = await into(transactions).insert(
        TransactionsCompanion(
          orderNumber: Value(orderNumber),
          totalAmount: Value(totalAmount),
          totalItems: Value(totalItems),
          createdAt: Value(DateTime.now()),
          note: Value(note),
        ),
      );
 
      for (final item in items) {
        await into(transactionItems).insert(
          TransactionItemsCompanion(
            transactionId: Value(txnId),
            productId: Value(item.product.id!),
            productCategory: Value(item.product.category),
            productName: Value(item.product.name),
            productBarcode: Value(item.product.barcode),
            productPrice: Value(item.product.price),
            productImagePath: Value(item.product.imagePath),
            quantity: Value(item.quantity),
            subtotal: Value(item.subtotal),
          ),
        );
      }
      return txnId;
    });
  }
 
  Future<List<TransactionModel>> getAllTransactions() async {
    final txnRows = await (select(transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
 
    final result = <TransactionModel>[];
    for (final txn in txnRows) {
      final itemRows = await (select(transactionItems)
            ..where((t) => t.transactionId.equals(txn.id)))
          .get();
      result.add(_rowToTransactionModel(txn, itemRows));
    }
    return result;
  }
 
  Future<TransactionModel?> getTransactionById(int id) async {
    final txn = await (select(transactions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (txn == null) return null;
    final itemRows = await (select(transactionItems)
          ..where((t) => t.transactionId.equals(id)))
        .get();
    return _rowToTransactionModel(txn, itemRows);
  }
 
 
  Future<void> deleteTransaction(int id) async {
    await (delete(transactionItems)..where((t) => t.transactionId.equals(id))).go();
    await (delete(transactions)..where((t) => t.id.equals(id))).go();
  }
 
  Future<void> clearAllTransactions() async {
    await delete(transactionItems).go();
    await delete(transactions).go();
  }
 
  Future<int> getTodayTransactionCount() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final rows = await (select(transactions)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(startOfDay) &
              t.createdAt.isSmallerThanValue(endOfDay)))
        .get();
    return rows.length;
  }
 
  // ── Helpers ───────────────────────────────────────────────────────────
 
  ProductModel _rowToProductModel(Product row) => ProductModel(
        id: row.id,
        name: row.name,
        barcode: row.barcode,
        price: row.price,
        description: row.description,
        category: row.category,
        quantity: row.quantity,
        imagePath: row.imagePath,
        isActive: row.isActive,
        createdAt: row.createdAt,
      );
 
  ProductsCompanion _productToCompanion(ProductModel m) => ProductsCompanion(
        id: m.id != null ? Value(m.id!) : const Value.absent(),
        name: Value(m.name),
        barcode: Value(m.barcode),
        price: Value(m.price),
        description: Value(m.description),
        category: Value(m.category),
        quantity: Value(m.quantity),
        imagePath: Value(m.imagePath),
        isActive: Value(m.isActive),
        createdAt: Value(m.createdAt),
      );
 
  TransactionModel _rowToTransactionModel(
      Transaction txn, List<TransactionItem> itemRows) {
    return TransactionModel(
      id: txn.id,
      orderNumber: txn.orderNumber,
      timestamp: txn.createdAt,
      totalAmount: txn.totalAmount,
      note: txn.note,
      items: itemRows
          .map((i) => ScannedItem(
                productId: i.productId,
                productName: i.productName,
                barcode: i.productBarcode,
                price: i.productPrice,
                imagePath: i.productImagePath,
                productCategory: i.productCategory,
                quantity: i.quantity,
              ))
          .toList(),
    );
  }
}
 
// ── Connection ─────────────────────────────────────────────────────────────
 
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'scanner_app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
 
AppDatabase? _instance;
AppDatabase get database {
  _instance ??= AppDatabase();
  return _instance!;
}