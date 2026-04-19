import 'package:smartinevntary/features/products/domain/entities/product.dart';
import 'package:smartinevntary/features/products/domain/repositories/product_repository.dart';

class GetProductById {
  final ProductRepository productRepository;
  GetProductById(this.productRepository);
  Future<Product?> call(String id) async {
    return await productRepository.getProductsById(id);
  }
}
