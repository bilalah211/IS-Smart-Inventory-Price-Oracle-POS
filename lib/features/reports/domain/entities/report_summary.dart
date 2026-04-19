class ReportSummary {
  final double totalRevenue;
  final int totalItems;
  final int totalTransactions;
  final List<ProductGroup> topProduct;

  ReportSummary({
    required this.totalRevenue,
    required this.totalItems,
    required this.totalTransactions,
    required this.topProduct,
  });
}

class ProductGroup {
  final String productName;
  final int totalQty;
  final double totalAmount;

  ProductGroup({
    required this.productName,
    required this.totalQty,
    required this.totalAmount,
  });
}
