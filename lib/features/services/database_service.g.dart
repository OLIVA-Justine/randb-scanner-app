// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'database_service.dart';

// ignore_for_file: type=lint

// ── Product DataClass ──────────────────────────────────────────────────────

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final String? description;
  final String? category;
  final int? quantity;
  final String? imagePath;
  final bool isActive;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    this.description,
    this.category,
    this.quantity,
    this.imagePath,
    required this.isActive,
    required this.createdAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['barcode'] = Variable<String>(barcode);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || description != null) map['description'] = Variable<String>(description);
    if (!nullToAbsent || category != null) map['category'] = Variable<String>(category);
    if (!nullToAbsent || quantity != null) map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || imagePath != null) map['image_path'] = Variable<String>(imagePath);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  factory Product.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String>(json['barcode']),
      price: serializer.fromJson<double>(json['price']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      quantity: serializer.fromJson<int?>(json['quantity']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String>(barcode),
      'price': serializer.toJson<double>(price),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String?>(category),
      'quantity': serializer.toJson<int?>(quantity),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Product copyWith({
    int? id, String? name, String? barcode, double? price,
    Value<String?> description = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<int?> quantity = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    bool? isActive, DateTime? createdAt,
  }) => Product(
    id: id ?? this.id, name: name ?? this.name,
    barcode: barcode ?? this.barcode, price: price ?? this.price,
    description: description.present ? description.value : this.description,
    category: category.present ? category.value : this.category,
    quantity: quantity.present ? quantity.value : this.quantity,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    isActive: isActive ?? this.isActive, createdAt: createdAt ?? this.createdAt,
  );

  @override
  String toString() => 'Product(id:$id, name:$name, barcode:$barcode, price:$price)';
  @override
  int get hashCode => Object.hash(id, name, barcode, price, description, category, quantity, imagePath, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Product && other.id == id && other.name == name && other.barcode == barcode);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> barcode;
  final Value<double> price;
  final Value<String?> description;
  final Value<String?> category;
  final Value<int?> quantity;
  final Value<String?> imagePath;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;

  const ProductsCompanion({
    this.id = const Value.absent(), this.name = const Value.absent(),
    this.barcode = const Value.absent(), this.price = const Value.absent(),
    this.description = const Value.absent(), this.category = const Value.absent(),
    this.quantity = const Value.absent(), this.imagePath = const Value.absent(),
    this.isActive = const Value.absent(), this.createdAt = const Value.absent(),
  });

  ProductsCompanion.insert({
    this.id = const Value.absent(), required String name, required String barcode,
    required double price, this.description = const Value.absent(),
    this.category = const Value.absent(), this.quantity = const Value.absent(),
    this.imagePath = const Value.absent(), this.isActive = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name), barcode = Value(barcode), price = Value(price), createdAt = Value(createdAt);

  ProductsCompanion copyWith({
    Value<int>? id, Value<String>? name, Value<String>? barcode, Value<double>? price,
    Value<String?>? description, Value<String?>? category, Value<int?>? quantity,
    Value<String?>? imagePath, Value<bool>? isActive, Value<DateTime>? createdAt,
  }) => ProductsCompanion(
    id: id ?? this.id, name: name ?? this.name, barcode: barcode ?? this.barcode,
    price: price ?? this.price, description: description ?? this.description,
    category: category ?? this.category, quantity: quantity ?? this.quantity,
    imagePath: imagePath ?? this.imagePath, isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (name.present) map['name'] = Variable<String>(name.value);
    if (barcode.present) map['barcode'] = Variable<String>(barcode.value);
    if (price.present) map['price'] = Variable<double>(price.value);
    if (description.present) map['description'] = Variable<String>(description.value);
    if (category.present) map['category'] = Variable<String>(category.value);
    if (quantity.present) map['quantity'] = Variable<int>(quantity.value);
    if (imagePath.present) map['image_path'] = Variable<String>(imagePath.value);
    if (isActive.present) map['is_active'] = Variable<bool>(isActive.value);
    if (createdAt.present) map['created_at'] = Variable<DateTime>(createdAt.value);
    return map;
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>('barcode', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<double> price = GeneratedColumn<double>('price', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> category = GeneratedColumn<String>('category', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>('quantity', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>('image_path', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>('is_active', aliasedName, false,
      type: DriftSqlType.bool, requiredDuringInsert: false, defaultValue: const Constant(true));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);

  @override List<GeneratedColumn> get $columns => [id, name, barcode, price, description, category, quantity, imagePath, isActive, createdAt];
  @override String get aliasedName => _alias ?? actualTableName;
  @override String get actualTableName => 'products';

  @override
  VerificationContext validateIntegrity(Insertable<Product> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) context.handle(const VerificationMeta('id'), id.isAcceptableOrUnknown(data['id']!, const VerificationMeta('id')));
    if (data.containsKey('name')) context.handle(const VerificationMeta('name'), name.isAcceptableOrUnknown(data['name']!, const VerificationMeta('name')));
    else if (isInserting) context.missing(const VerificationMeta('name'));
    if (data.containsKey('barcode')) context.handle(const VerificationMeta('barcode'), barcode.isAcceptableOrUnknown(data['barcode']!, const VerificationMeta('barcode')));
    else if (isInserting) context.missing(const VerificationMeta('barcode'));
    if (data.containsKey('price')) context.handle(const VerificationMeta('price'), price.isAcceptableOrUnknown(data['price']!, const VerificationMeta('price')));
    else if (isInserting) context.missing(const VerificationMeta('price'));
    if (data.containsKey('created_at')) context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    else if (isInserting) context.missing(const VerificationMeta('createdAt'));
    return context;
  }

  @override Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final p = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}name'])!,
      barcode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}barcode'])!,
      price: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${p}price'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}description']),
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}category']),
      quantity: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}quantity']),
      imagePath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}image_path']),
      isActive: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${p}is_active'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${p}created_at'])!,
    );
  }

  @override $ProductsTable createAlias(String alias) => $ProductsTable(attachedDatabase, alias);
}

// ── Transaction DataClass ──────────────────────────────────────────────────

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final int totalItems;
  final DateTime createdAt;
  final String? note;

  const Transaction({
    required this.id, required this.orderNumber, required this.totalAmount,
    required this.totalItems, required this.createdAt, this.note,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_number'] = Variable<String>(orderNumber);
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_items'] = Variable<int>(totalItems);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || note != null) map['note'] = Variable<String>(note);
    return map;
  }

  factory Transaction.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalItems: serializer.fromJson<int>(json['totalItems']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {
      'id': serializer.toJson<int>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalItems': serializer.toJson<int>(totalItems),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  Transaction copyWith({int? id, String? orderNumber, double? totalAmount, int? totalItems, DateTime? createdAt, Value<String?> note = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id, orderNumber: orderNumber ?? this.orderNumber,
        totalAmount: totalAmount ?? this.totalAmount, totalItems: totalItems ?? this.totalItems,
        createdAt: createdAt ?? this.createdAt,
        note: note.present ? note.value : this.note,
      );

  @override String toString() => 'Transaction(id:$id, orderNumber:$orderNumber, total:$totalAmount)';
  @override int get hashCode => Object.hash(id, orderNumber, totalAmount, totalItems, createdAt, note);
  @override bool operator ==(Object other) => identical(this, other) || (other is Transaction && other.id == id);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String> orderNumber;
  final Value<double> totalAmount;
  final Value<int> totalItems;
  final Value<DateTime> createdAt;
  final Value<String?> note;

  const TransactionsCompanion({
    this.id = const Value.absent(), this.orderNumber = const Value.absent(),
    this.totalAmount = const Value.absent(), this.totalItems = const Value.absent(),
    this.createdAt = const Value.absent(), this.note = const Value.absent(),
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (orderNumber.present) map['order_number'] = Variable<String>(orderNumber.value);
    if (totalAmount.present) map['total_amount'] = Variable<double>(totalAmount.value);
    if (totalItems.present) map['total_items'] = Variable<int>(totalItems.value);
    if (createdAt.present) map['created_at'] = Variable<DateTime>(createdAt.value);
    if (note.present) map['note'] = Variable<String>(note.value);
    return map;
  }
}

class $TransactionsTable extends Transactions with TableInfo<$TransactionsTable, Transaction> {
  @override final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>('order_number', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>('total_amount', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<int> totalItems = GeneratedColumn<int>('total_items', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> note = GeneratedColumn<String>('note', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);

  @override List<GeneratedColumn> get $columns => [id, orderNumber, totalAmount, totalItems, createdAt, note];
  @override String get aliasedName => _alias ?? actualTableName;
  @override String get actualTableName => 'transactions';

  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('order_number')) context.handle(const VerificationMeta('orderNumber'), orderNumber.isAcceptableOrUnknown(data['order_number']!, const VerificationMeta('orderNumber')));
    else if (isInserting) context.missing(const VerificationMeta('orderNumber'));
    if (data.containsKey('total_amount')) context.handle(const VerificationMeta('totalAmount'), totalAmount.isAcceptableOrUnknown(data['total_amount']!, const VerificationMeta('totalAmount')));
    else if (isInserting) context.missing(const VerificationMeta('totalAmount'));
    if (data.containsKey('total_items')) context.handle(const VerificationMeta('totalItems'), totalItems.isAcceptableOrUnknown(data['total_items']!, const VerificationMeta('totalItems')));
    else if (isInserting) context.missing(const VerificationMeta('totalItems'));
    if (data.containsKey('created_at')) context.handle(const VerificationMeta('createdAt'), createdAt.isAcceptableOrUnknown(data['created_at']!, const VerificationMeta('createdAt')));
    else if (isInserting) context.missing(const VerificationMeta('createdAt'));
    return context;
  }

  @override Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final p = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}id'])!,
      orderNumber: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}order_number'])!,
      totalAmount: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${p}total_amount'])!,
      totalItems: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}total_items'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${p}created_at'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}note']),
    );
  }

  @override $TransactionsTable createAlias(String alias) => $TransactionsTable(attachedDatabase, alias);
}

// ── TransactionItem DataClass ──────────────────────────────────────────────

class TransactionItem extends DataClass implements Insertable<TransactionItem> {
  final int id;
  final int transactionId;
  final int productId;
  final String productName;
  final String productBarcode;
  final double productPrice;
  final String? productImagePath;
  final String? productCategory;
  final int quantity;
  final double subtotal;

  const TransactionItem({
    required this.id, required this.transactionId, required this.productId,
    required this.productName, required this.productBarcode, required this.productPrice,
    this.productImagePath, this.productCategory, required this.quantity, required this.subtotal,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['product_barcode'] = Variable<String>(productBarcode);
    map['product_price'] = Variable<double>(productPrice);
    if (!nullToAbsent || productImagePath != null) map['product_image_path'] = Variable<String>(productImagePath);
    if (!nullToAbsent || productCategory != null) map['product_category'] = Variable<String>(productCategory);
    map['quantity'] = Variable<int>(quantity);
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItem(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      productBarcode: serializer.fromJson<String>(json['productBarcode']),
      productPrice: serializer.fromJson<double>(json['productPrice']),
      productImagePath: serializer.fromJson<String?>(json['productImagePath']),
      quantity: serializer.fromJson<int>(json['quantity']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
    );
  }

  @override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {
      'id': serializer.toJson<int>(id), 'transactionId': serializer.toJson<int>(transactionId),
      'productId': serializer.toJson<int>(productId), 'productName': serializer.toJson<String>(productName),
      'productBarcode': serializer.toJson<String>(productBarcode), 'productPrice': serializer.toJson<double>(productPrice),
      'productImagePath': serializer.toJson<String?>(productImagePath),
      'quantity': serializer.toJson<int>(quantity), 'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  @override String toString() => 'TransactionItem(id:$id, product:$productName, qty:$quantity)';
  @override int get hashCode => Object.hash(id, transactionId, productId, quantity, subtotal);
  @override bool operator ==(Object other) => identical(this, other) || (other is TransactionItem && other.id == id);
}

class TransactionItemsCompanion extends UpdateCompanion<TransactionItem> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<String> productBarcode;
  final Value<double> productPrice;
  final Value<String?> productImagePath;
  final Value<String?> productCategory;
  final Value<int> quantity;
  final Value<double> subtotal;

  const TransactionItemsCompanion({
    this.id = const Value.absent(), this.transactionId = const Value.absent(),
    this.productId = const Value.absent(), this.productName = const Value.absent(),
    this.productBarcode = const Value.absent(), this.productPrice = const Value.absent(),
    this.productImagePath = const Value.absent(), this.productCategory = const Value.absent(),
    this.quantity = const Value.absent(),
    this.subtotal = const Value.absent(),
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (transactionId.present) map['transaction_id'] = Variable<int>(transactionId.value);
    if (productId.present) map['product_id'] = Variable<int>(productId.value);
    if (productName.present) map['product_name'] = Variable<String>(productName.value);
    if (productBarcode.present) map['product_barcode'] = Variable<String>(productBarcode.value);
    if (productPrice.present) map['product_price'] = Variable<double>(productPrice.value);
    if (productImagePath.present) map['product_image_path'] = Variable<String>(productImagePath.value);
    if (productCategory.present) map['product_category'] = Variable<String>(productCategory.value);
    if (quantity.present) map['quantity'] = Variable<int>(quantity.value);
    if (subtotal.present) map['subtotal'] = Variable<double>(subtotal.value);
    return map;
  }
}

class $TransactionItemsTable extends TransactionItems with TableInfo<$TransactionItemsTable, TransactionItem> {
  @override final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);

  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>('transaction_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> productId = GeneratedColumn<int>('product_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> productName = GeneratedColumn<String>('product_name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> productBarcode = GeneratedColumn<String>('product_barcode', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<double> productPrice = GeneratedColumn<double>('product_price', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<String> productImagePath = GeneratedColumn<String>('product_image_path', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> productCategory = GeneratedColumn<String>('product_category', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>('quantity', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>('subtotal', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);

  @override List<GeneratedColumn> get $columns => [id, transactionId, productId, productName, productBarcode, productPrice, productImagePath, productCategory, quantity, subtotal];
  @override String get aliasedName => _alias ?? actualTableName;
  @override String get actualTableName => 'transaction_items';

  @override
  VerificationContext validateIntegrity(Insertable<TransactionItem> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) context.handle(const VerificationMeta('transactionId'), transactionId.isAcceptableOrUnknown(data['transaction_id']!, const VerificationMeta('transactionId')));
    else if (isInserting) context.missing(const VerificationMeta('transactionId'));
    if (data.containsKey('product_id')) context.handle(const VerificationMeta('productId'), productId.isAcceptableOrUnknown(data['product_id']!, const VerificationMeta('productId')));
    else if (isInserting) context.missing(const VerificationMeta('productId'));
    return context;
  }

  @override Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final p = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItem(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}id'])!,
      transactionId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}transaction_id'])!,
      productId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}product_id'])!,
      productName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}product_name'])!,
      productBarcode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}product_barcode'])!,
      productPrice: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${p}product_price'])!,
      productImagePath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}product_image_path']),
      productCategory: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${p}product_category']),
      quantity: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${p}quantity'])!,
      subtotal: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${p}subtotal'])!,
    );
  }

  @override $TransactionItemsTable createAlias(String alias) => $TransactionItemsTable(attachedDatabase, alias);
}

// ── Abstract DB ────────────────────────────────────────────────────────────

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $ProductsTable products = $ProductsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemsTable transactionItems = $TransactionItemsTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [products, transactions, transactionItems];
}