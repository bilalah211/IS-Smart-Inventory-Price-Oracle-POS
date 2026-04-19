import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';
import 'package:smartinevntary/features/inventory/domain/repositories/inventory_repository.dart';

class AddItemToInventory {
  InventoryRepository inventoryRepository;

  AddItemToInventory(this.inventoryRepository);

  Future<void> call(InventoryItem item) async {
    inventoryRepository.addProductToInventory(item);
  }
}
