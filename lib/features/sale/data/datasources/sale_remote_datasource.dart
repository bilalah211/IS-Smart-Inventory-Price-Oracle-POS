import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinevntary/core/constants/app_constants.dart';
import 'package:smartinevntary/features/sale/data/model/sale_model.dart';

class SaleRemoteDatasource {
  final FirebaseFirestore firestore;

  SaleRemoteDatasource(this.firestore);

  //---[Scan And Add Item]---
  Future<void> processSale(SaleModel sale) async {
    final inventoryDoc = firestore
        .collection(AppConstants.inventoryCollection)
        .doc(sale.productId);
    final saleDoc = firestore.collection(AppConstants.saleCollection).doc();

    return firestore.runTransaction((transaction) async {
      final inventorySnapshot = await transaction.get(inventoryDoc);

      if (!inventorySnapshot.exists) {
        throw Exception("Item not in inventory!");
      }

      final currentQuantity = int.parse(inventorySnapshot.get('quantity'));
      final sellQuantity = int.parse(sale.quantitySold);

      if (currentQuantity < sellQuantity) {
        throw Exception("Insufficient stock!");
      }
      transaction.update(inventoryDoc, {
        'quantity': (currentQuantity - sellQuantity).toString(),
      });
      transaction.set(saleDoc, sale.toMap());
    });
  }

  //---[Get Sale Items]---
  Future<List<SaleModel>> fetchSale() async {
    final snapshot = await firestore
        .collection(AppConstants.saleCollection)
        .orderBy('saleDate', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return SaleModel.fromMap(doc.data());
    }).toList();
  }
}
