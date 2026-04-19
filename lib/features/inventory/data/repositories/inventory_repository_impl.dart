import 'package:smartinevntary/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:smartinevntary/features/inventory/data/model/inventory_model.dart';
import 'package:smartinevntary/features/inventory/domain/entities/inventory.dart';
import 'package:smartinevntary/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDatasource inventoryRemoteDatasource;

  InventoryRepositoryImpl(this.inventoryRemoteDatasource);

  @override
  Future<void> addProductToInventory(InventoryItem item) async {
    final model = InventoryModel(
      productId: item.productId,
      quantity: item.quantity,
    );
    await inventoryRemoteDatasource.addItem(model);
  }

  @override
  Future<List<InventoryItem>> getAllItems() async {
    final data = await inventoryRemoteDatasource.getAllItems();
    return data;
  }

  @override
  Future<InventoryItem?> getItemByBarcode(String barcode) async {
    return await inventoryRemoteDatasource.getItem(barcode);
  }

  @override
  Future<void> updateStockQuantity(String id, String quantity) async {
    await inventoryRemoteDatasource.updateItemQuantity(id, quantity);
  }
}
