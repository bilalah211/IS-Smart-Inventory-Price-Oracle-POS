import 'package:smartinevntary/features/products/domain/entities/product.dart';

abstract class ProductStates {}

class InitialState extends ProductStates {}

class LoadingState extends ProductStates {}

class ProductsLoaded extends ProductStates {
  final List<Product> products;

  ProductsLoaded(this.products);
}

class ProductErrorState extends ProductStates {
  String message;

  ProductErrorState(this.message);
}
