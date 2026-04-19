import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/features/inventory/domain/usecases/add_item.dart';
import 'package:smartinevntary/features/inventory/domain/usecases/get_all_item.dart';
import 'package:smartinevntary/features/inventory/domain/usecases/get_item_by_barcode.dart';
import 'package:smartinevntary/features/inventory/domain/usecases/update_item.dart';
import 'package:smartinevntary/features/inventory/presentation/bloc/inventory_events.dart';
import 'package:smartinevntary/features/inventory/presentation/bloc/inventory_states.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final AddItemToInventory addItemToInventory;
  final GetAllItems getAllItems;
  final GetItemByBarcode getItemByBarcode;
  final UpdateItem updateItem;

  InventoryBloc(
    this.addItemToInventory,
    this.getAllItems,
    this.getItemByBarcode,
    this.updateItem,
  ) : super(InventoryInitial()) {
    on<PrepareSavingEvent>((event, emit) {
      emit(InventorySaving());
    });

    //---[ADD ITEM TO INVENTORY]---
    on<AddInventoryItem>((event, emit) async {
      emit(InventorySaving());
      try {
        await addItemToInventory.call(event.item);

        final items = await getAllItems.call();
        emit(InventoryLoaded(items));
      } catch (e) {
        emit(InventoryError("Failed to add item: ${e.toString()}"));
      }
    });

    //---[GET ALL ITEMS FROM INVENTORY]---
    on<GetAllInventoryItems>((event, emit) async {
      emit(InventoryLoading());
      try {
        final items = await getAllItems.call();
        emit(InventoryLoaded(items));
      } catch (e) {
        emit(InventoryError("Failed to add item: ${e.toString()}"));
      }
    });

    //---[GET ITEM BY BARCODE FROM INVENTORY]---
    on<FetchItemByBarcodeEvent>((event, emit) async {
      emit(InventoryLoading());
      try {
        final items = await getItemByBarcode.call(event.barcode);
        if (items != null) {
          emit(InventoryItemLoaded(items));
        }
      } catch (e) {
        emit(InventoryError("Failed To Scan Barcode: ${e.toString()}"));
      }
    });
  }
}
