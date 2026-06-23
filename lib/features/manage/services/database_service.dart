import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';


import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../models/product_model.dart';
part 'database_service.g.dart';

// ── Products table definition ─────────────────────────────────────────────

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

// ── Database ──────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── Products CRUD ─────────────────────────────────────────────────────

  Future<List<ProductModel>> getAllProducts() async {
    final rows = await select(products).get();
    return rows.map(_rowToModel).toList();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final rows = await (select(products)
          ..where((t) =>
              t.name.like('%$query%') | t.barcode.like('%$query%')))
        .get();
    return rows.map(_rowToModel).toList();
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    final row = await (select(products)
          ..where((t) => t.barcode.equals(barcode))
          ..limit(1))
        .getSingleOrNull();
    return row != null ? _rowToModel(row) : null;
  }

  Future<int> insertProduct(ProductModel model) async {
    return into(products).insert(_modelToCompanion(model));
  }

  Future<bool> updateProduct(ProductModel model) async {
    return update(products).replace(_modelToCompanion(model));
  }

  Future<int> deleteProduct(int id) async {
    return (delete(products)..where((t) => t.id.equals(id))).go();
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  ProductModel _rowToModel(Product row) {
    return ProductModel(
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
  }

  ProductsCompanion _modelToCompanion(ProductModel model) {
    return ProductsCompanion(
      id: model.id != null ? Value(model.id!) : const Value.absent(),
      name: Value(model.name),
      barcode: Value(model.barcode),
      price: Value(model.price),
      description: Value(model.description),
      category: Value(model.category),
      quantity: Value(model.quantity),
      imagePath: Value(model.imagePath),
      isActive: Value(model.isActive),
      createdAt: Value(model.createdAt),
    );
  }
}

// ── DB connection ─────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'scanner_app.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// ── Singleton accessor ────────────────────────────────────────────────────

AppDatabase? _instance;

AppDatabase get database {
  _instance ??= AppDatabase();
  return _instance!;
}