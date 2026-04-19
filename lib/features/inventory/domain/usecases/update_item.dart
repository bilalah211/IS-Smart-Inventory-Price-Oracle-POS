import '../repositories/inventory_repository.dart';

class UpdateItem {
  InventoryRepository inventoryRepository;

  UpdateItem(this.inventoryRepository);

  Future<void> call(String barcode, String quantity) async {
    await inventoryRepository.updateStockQuantity(barcode, quantity);
  }
}
