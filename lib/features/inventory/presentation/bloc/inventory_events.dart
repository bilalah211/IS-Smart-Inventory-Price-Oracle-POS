import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';

abstract class InventoryEvent {}

class GetAllInventoryItems extends InventoryEvent {
  GetAllInventoryItems();
}

class AddInventoryItem extends InventoryEvent {
  final InventoryItem item;

  AddInventoryItem(this.item);
}

class FetchItemByBarcodeEvent extends InventoryEvent {
  final String barcode;
  FetchItemByBarcodeEvent(this.barcode);
}

class PrepareSavingEvent extends InventoryEvent {
  PrepareSavingEvent();
}

class UpdateInventoryItemQuantity extends InventoryEvent {
  String id;
  double newQuantity;

  UpdateInventoryItemQuantity(this.id, this.newQuantity);
}
