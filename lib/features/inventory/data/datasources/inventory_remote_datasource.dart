import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinevntary/core/constants/app_constants.dart';
import 'package:smartinevntary/features/inventory/data/model/inventory_model.dart';

class InventoryRemoteDatasource {
  FirebaseFirestore firestore;

  InventoryRemoteDatasource(this.firestore);

  //---[ADD ITEM TO FIRESTORE]---
  Future<void> addItem(InventoryModel item) async {
    await firestore
        .collection(AppConstants.inventoryCollection)
        .doc(item.productId)
        .set({...item.toMap(), 'createdAt': FieldValue.serverTimestamp()});
  }

  //---[GET ALL ITEMS FROM FIRESTORE]---
  Future<List<InventoryModel>> getAllItems() async {
    final snapshot = await firestore
        .collection(AppConstants.inventoryCollection)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return InventoryModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  //---[GET ITEM BY BARCODE FROM FIRESTORE]---
  Future<InventoryModel?> getItem(String barcode) async {
    final snapshot = await firestore
        .collection(AppConstants.inventoryCollection)
        .where('productId', isEqualTo: barcode)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return InventoryModel.fromMap(
        snapshot.docs.first.data(),
        snapshot.docs.first.id,
      );
    } else {
      return null;
    }
  }

  //---[UPDATE ITEM QUANTITY IN FIRESTORE]---
  Future<void> updateItemQuantity(String id, String newQuantity) async {
    firestore.collection(AppConstants.inventoryCollection).doc(id).update({
      'quantity': newQuantity,
      'last updated': Timestamp.now(),
    });
  }
}
