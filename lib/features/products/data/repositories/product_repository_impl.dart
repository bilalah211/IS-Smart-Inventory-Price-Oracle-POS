import 'package:smartinevntary/features/products/data/datasources/product_remote_datasource.dart';
import 'package:smartinevntary/features/products/data/models/product_model.dart';
import 'package:smartinevntary/features/products/domain/entities/product.dart';
import 'package:smartinevntary/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource productRemoteDatasource;

  ProductRepositoryImpl(this.productRemoteDatasource);

  @override
  Future<String> addProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
    );
    return await productRemoteDatasource.addProduct(model.toMap(), product.id);
  }

  @override
  Future<List<Product>> getProducts() async {
    final product = await productRemoteDatasource.getProducts();

    return product.map((data) {
      return ProductModel.fromFirestore(data, data['id']);
    }).toList();
  }

  @override
  Future<Product?> getProductsById(String id) async {
    final product = await productRemoteDatasource.getProductById(id);
    if (product == null) {
      return null;
    }
    return ProductModel.fromFirestore(product, id);
  }
}
