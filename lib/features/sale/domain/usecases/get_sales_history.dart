import 'package:smartinevntary/features/sale/domain/entities/sale.dart';
import 'package:smartinevntary/features/sale/domain/repositories/sale_repository.dart';

class GetSalesHistory {
  final SaleRepository saleRepository;

  GetSalesHistory(this.saleRepository);

  Future<List<SaleItem>> call() async {
    return await saleRepository.getSaleHistory();
  }
}
