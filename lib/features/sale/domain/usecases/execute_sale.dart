import 'package:smartinevntary/features/sale/domain/entities/sale.dart';
import 'package:smartinevntary/features/sale/domain/repositories/sale_repository.dart';

class ExecuteSale {
  final SaleRepository saleRepository;
  ExecuteSale(this.saleRepository);

  Future<void> call(SaleItem saleItem) async {
    await saleRepository.executeSale(saleItem);
  }
}
