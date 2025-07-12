

import '../barcode/item.dart' show Item;

class OrderRequest {
  final DateTime createdAt;
  final List<Item> items;

  OrderRequest({required this.createdAt, required this.items});

  Map<String, dynamic> toMap() => {
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((item) => item.toMap()).toList(),
  };

  factory OrderRequest.fromMap(Map<String, dynamic> map) {
    return OrderRequest(
      createdAt: DateTime.parse(map['createdAt'] as String),
      items: (map['items'] as List)
          .map((item) => Item.fromMap(item))
          .toList(),
    );
  }
}
