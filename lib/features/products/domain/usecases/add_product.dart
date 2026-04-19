import 'package:smartinevntary/features/products/domain/entities/product.dart';
import 'package:smartinevntary/features/products/domain/repositories/product_repository.dart';

class AddProduct {
  final ProductRepository productRepository;

  AddProduct(this.productRepository);

  Future<void> addProduct(Product product) async {
    await productRepository.addProduct(product);
  }
}
