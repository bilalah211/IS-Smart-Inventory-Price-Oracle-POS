import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.image,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      title: data['title'] ?? '',
      // Use num.tryParse if it's a String, or cast if it's already a num
      price: _parsePrice(data['price']),
      image: data['image'] ?? '',
    );
  }

  // Helper function to handle both "50.0" (String) and 50.0 (double/int)
  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "price": price, "image": image};
  }
}
