import '../../domain/entities/inventory.dart';

class InventoryModel extends InventoryItem {
  InventoryModel({required super.productId, required super.quantity});

  factory InventoryModel.fromMap(Map<String, dynamic> map, String id) {
    return InventoryModel(
      productId: map['productId'] ?? id,
      quantity: map['quantity']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toMap() {
    return {'productId': productId, 'quantity': quantity};
  }

  factory InventoryModel.fromEntity(InventoryItem entity) {
    return InventoryModel(
      productId: entity.productId,
      quantity: entity.quantity,
    );
  }
}
