import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';
import 'package:smartinevntary/features/inventory/domain/repositories/inventory_repository.dart';

class GetAllItems {
  InventoryRepository inventoryRepository;

  GetAllItems(this.inventoryRepository);

  Future<List<InventoryItem>> call() async {
    return await inventoryRepository.getAllItems();
  }
}
