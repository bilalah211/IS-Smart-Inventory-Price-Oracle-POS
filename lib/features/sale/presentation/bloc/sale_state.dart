import 'package:smartinevntary/features/sale/domain/entities/sale.dart';

abstract class SaleState {}

class InitialSaleState extends SaleState {}

class LoadingSaleState extends SaleState {}

class LoadedScannedState extends SaleState {
  final dynamic product;
  final String stock;

  LoadedScannedState(this.product, this.stock);
}

class LoadedSaleState extends SaleState {
  final List<SaleItem> saleItem;

  LoadedSaleState(this.saleItem);
}

class ErrorSaleState extends SaleState {
  String message;

  ErrorSaleState(this.message);
}
