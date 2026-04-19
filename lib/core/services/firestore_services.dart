import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //SAVE DATA TO FIRESTORE
  Future<void> saveDataToFirestore(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection(collection).doc(docId).set(data);
  }

  //GET DATA FROM FIRESTORE
  Future<DocumentSnapshot<Map<String, dynamic>>> getDataFromFirestore(
    String collection,
    String docId,
  ) async {
    return await firestore.collection(collection).doc(docId).get();
  }
}
