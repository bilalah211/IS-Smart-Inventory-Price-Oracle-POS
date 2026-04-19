import 'package:smartinevntary/features/products/domain/entities/product.dart';

abstract class ProductEvents {}

class AddProductEvent extends ProductEvents {
  final Product product;

  AddProductEvent(this.product);
}

class LoadProduct extends ProductEvents {}

class GetProductsById extends ProductEvents {
  String id;

  GetProductsById(this.id);
}
