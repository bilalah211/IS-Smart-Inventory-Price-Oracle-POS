import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventorySaving extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;

  InventoryLoaded(this.items);
}

class InventoryItemLoaded extends InventoryState {
  final InventoryItem item;

  InventoryItemLoaded(this.item);
}

class InventoryError extends InventoryState {
  final String message;

  InventoryError(this.message);
}
