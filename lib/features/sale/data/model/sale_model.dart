import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/sale.dart';

class SaleModel extends SaleItem {
  SaleModel({
    required super.productId,
    required super.productName,
    required super.productPrice,
    required super.quantitySold,
    required super.saleDate,
  });

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice']?.toString() ?? '0',
      quantitySold: map['quantitySold']?.toString() ?? '0',
      saleDate: (map['saleDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantitySold': quantitySold,
      'saleDate': Timestamp.fromDate(saleDate),
    };
  }
}
