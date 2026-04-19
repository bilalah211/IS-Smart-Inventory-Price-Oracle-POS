import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartinevntary/core/constants/app_constants.dart';

class ProductRemoteDatasource {
  final FirebaseFirestore firestore;

  ProductRemoteDatasource(this.firestore);

  Future<List<Map<String, dynamic>>> getProducts() async {
    final snapshot = await firestore
        .collection(AppConstants.productCollection)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }

  Future<Map<String, dynamic>?> getProductById(String id) async {
    final doc = await firestore
        .collection(AppConstants.productCollection)
        .doc(id)
        .get();
    return doc.exists ? doc.data() : null;
  }

  Future<String> addProduct(Map<String, dynamic> product, String id) async {
    final docRef = firestore.collection(AppConstants.productCollection).doc(id);
    await docRef.set(product);
    return docRef.id;
  }
}
