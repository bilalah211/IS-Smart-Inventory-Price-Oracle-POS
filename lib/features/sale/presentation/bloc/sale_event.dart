import '../../domain/entities/sale.dart';

abstract class SalesEvent {}

class ScanBarcodeEvent extends SalesEvent {
  final String barcode;

  ScanBarcodeEvent(this.barcode);
}

class ExecuteSaleEvent extends SalesEvent {
  final List<SaleItem> saleItems;

  ExecuteSaleEvent(this.saleItems);
}

class GetAllSalesEvent extends SalesEvent {}
