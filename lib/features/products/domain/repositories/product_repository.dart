import 'package:smartinevntary/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getProductsById(String id);

  Future<void> addProduct(Product product);
}
