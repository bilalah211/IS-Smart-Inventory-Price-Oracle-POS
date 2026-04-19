import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';

abstract class InventoryRepository {
  //ADD PRODUCT TO INVENTORY
  Future<void> addProductToInventory(InventoryItem item);

  //GET ALL PRODUCTS FROM INVENTORY
  Future<List<InventoryItem>> getAllItems();

  //GET PRODUCT BY BARCODE
  Future<InventoryItem?> getItemByBarcode(String barcode);

  //UPDATE QUANTITY
  Future<void> updateStockQuantity(String barcode, String quantity);
}
