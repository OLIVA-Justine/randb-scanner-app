class TransactionModel {
  final int? id;
  final String orderNumber;
  final DateTime timestamp;
  final double totalAmount;
  final String? note;
  final List<ScannedItem> items;

  TransactionModel({
    this.id,
    required this.orderNumber,
    required this.timestamp,
    required this.totalAmount,
    this.note,
    required this.items,
  });

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get formattedDate {
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year}';
  }

  String get formattedTotal => '₱${totalAmount.toStringAsFixed(2)}';
}

class ScannedItem {
  final int productId;
  final String productName;
  final String? productCategory;
  final String barcode;
  final double price;
  final String? imagePath;
  final int quantity;

  ScannedItem({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.barcode,
    required this.price,
    this.imagePath,
    required this.quantity,
  });

  double get subtotal => price * quantity;
  String get formattedPrice => '₱${price.toStringAsFixed(2)}';
  String get formattedSubtotal => '₱${subtotal.toStringAsFixed(2)}';
}

// CartItem is used during an active scanning session
class CartItem {
  final dynamic product; // ProductModel
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => (product.price as double) * quantity;
  String get formattedSubtotal => '₱${subtotal.toStringAsFixed(2)}';
}