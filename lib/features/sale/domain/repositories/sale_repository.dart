import 'package:smartinevntary/features/sale/domain/entities/sale.dart';

abstract class SaleRepository {
  Future<List<SaleItem>> getSaleHistory();

  Future<void> executeSale(SaleItem saleItem);
}
