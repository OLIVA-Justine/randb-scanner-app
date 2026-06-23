class TransactionModel {
  final String id;
  final String orderNumber;
  final DateTime timestamp;
  final List<ScannedItem> items;
  final double totalAmount;

  TransactionModel({
    required this.id,
    required this.orderNumber,
    required this.timestamp,
    required this.items,
    required this.totalAmount,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get formattedDate {
    return '${timestamp.month.toString().padLeft(2, '0')}'
        '${timestamp.day.toString().padLeft(2, '0')}'
        '${timestamp.year}';
  }
}

class ScannedItem {
  final String barcode;
  final String productName;
  final double price;
  final int quantity;

  ScannedItem({
    required this.barcode,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;
}