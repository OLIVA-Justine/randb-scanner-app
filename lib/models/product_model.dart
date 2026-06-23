class ProductModel {
  final int? id;
  final String name;
  final String barcode;
  final double price;
  final String? description;
  final String? category;
  final int? quantity;
  final String? imagePath;
  final bool isActive;
  final DateTime createdAt;

  ProductModel({
    this.id,
    required this.name,
    required this.barcode,
    required this.price,
    this.description,
    this.category,
    this.quantity,
    this.imagePath,
    this.isActive = true,
    required this.createdAt,
  });

  ProductModel copyWith({
    int? id,
    String? name,
    String? barcode,
    double? price,
    String? description,
    String? category,
    int? quantity,
    String? imagePath,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get formattedPrice => '₱${price.toStringAsFixed(2)}';
}