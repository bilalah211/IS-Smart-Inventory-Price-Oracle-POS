import 'package:smartinevntary/features/sale/data/datasources/sale_remote_datasource.dart';
import 'package:smartinevntary/features/sale/data/model/sale_model.dart';
import 'package:smartinevntary/features/sale/domain/entities/sale.dart';

import '../../domain/repositories/sale_repository.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDatasource saleRemoteDatasource;

  SaleRepositoryImpl(this.saleRemoteDatasource);

  @override
  Future<void> executeSale(SaleItem sale) async {
    final saleItem = SaleModel(
      productId: sale.productId,
      productName: sale.productName,
      productPrice: sale.productPrice,
      quantitySold: sale.quantitySold,
      saleDate: sale.saleDate,
    );
    await saleRemoteDatasource.processSale(saleItem);
  }

  @override
  Future<List<SaleItem>> getSaleHistory() async {
    return await saleRemoteDatasource.fetchSale();
  }
}
