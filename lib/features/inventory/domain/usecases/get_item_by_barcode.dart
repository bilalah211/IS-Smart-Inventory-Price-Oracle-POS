import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';

import '../repositories/inventory_repository.dart';

class GetItemByBarcode {
  InventoryRepository inventoryRepository;

  GetItemByBarcode(this.inventoryRepository);

  Future<InventoryItem?> call(String barcode) async {
    return inventoryRepository.getItemByBarcode(barcode);
  }
}
