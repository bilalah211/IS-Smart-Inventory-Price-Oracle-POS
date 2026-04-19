import 'package:smartinevntary/features/products/domain/entities/product.dart';
import 'package:smartinevntary/features/products/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository productRepository;
  GetProducts(this.productRepository);
  Future<List<Product>> getProducts() async {
    return productRepository.getProducts();
  }
}
