import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartinevntary/features/products/data/repositories/product_repository_impl.dart';
import 'package:smartinevntary/features/products/domain/entities/product.dart';
import 'package:smartinevntary/features/products/domain/usecases/get_products.dart';
import 'package:smartinevntary/features/products/presentation/bloc/product_events.dart';
import 'package:smartinevntary/features/products/presentation/bloc/product_states.dart';

class ProductsBloc extends Bloc<ProductEvents, ProductStates> {
  final ProductRepositoryImpl repositoryImpl;

  ProductsBloc(this.repositoryImpl) : super(InitialState()) {
    on<AddProductEvent>((event, emit) async {
      final product = Product(
        id: '',
        title: event.product.title,
        price: event.product.price,
        image: event.product.image,
      );
      await repositoryImpl.addProduct(product);
      final products = await repositoryImpl.getProducts();
      emit(ProductsLoaded(products));
    });

    on<LoadProduct>((event, emit) async {
      final products = await repositoryImpl.getProducts();

      emit(ProductsLoaded(products));
    });
    on<GetProductsById>((event, emit) async {
      emit(LoadingState()); // Trigger the loader in the dialog
      try {
        final product = await repositoryImpl.getProductsById(event.id);

        List<Product> currentList = [];

        // Check if we already have a list in the current state
        if (state is ProductsLoaded) {
          currentList = List.from((state as ProductsLoaded).products);
        }

        // Add the scanned product if it's not already in the list
        if (!currentList.any((p) => p.id == product!.id)) {
          currentList.add(product!);
        }

        emit(ProductsLoaded(currentList));
      } catch (e) {
        emit(ProductErrorState(e.toString()));
      }
    });
  }
}
