import '../../../sale/data/datasources/sale_remote_datasource.dart';
import '../../domain/entities/report_summary.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final SaleRemoteDatasource saleRemoteDatasource;

  ReportRepositoryImpl(this.saleRemoteDatasource);

  @override
  Future<ReportSummary> getDailyReport(DateTime date) async {
    final totalSale = await saleRemoteDatasource.fetchSale();

    final totalItems = totalSale.where((sale) {
      return sale.saleDate.year == date.year &&
          sale.saleDate.month == date.month &&
          sale.saleDate.day == date.day;
    }).toList();

    final revenue = totalItems.fold<double>(0, (sum, sale) {
      final qty = int.tryParse(sale.quantitySold) ?? 0;
      final price = int.tryParse(sale.productPrice) ?? 0;
      return sum + qty * price;
    });

    final items = totalSale.fold<int>(0, (sum, sale) {
      return sum + (int.tryParse(sale.quantitySold) ?? 0);
    });

    Map<String, ProductGroup> group = {};

    for (var s in totalSale) {
      final q = int.tryParse(s.quantitySold) ?? 0;
      final p = double.tryParse(s.productPrice) ?? 0;

      group.update(
        s.productName,
        (old) => ProductGroup(
          productName: s.productName,
          totalQty: old.totalQty + q,
          totalAmount: old.totalAmount + (q * p),
        ),
        ifAbsent: () => ProductGroup(
          productName: s.productName,
          totalQty: q,
          totalAmount: q * p,
        ),
      );
    }

    return ReportSummary(
      totalRevenue: revenue,
      totalItems: items,
      totalTransactions: totalSale.length,
      topProduct: group.values.toList(),
    );
  }
}
