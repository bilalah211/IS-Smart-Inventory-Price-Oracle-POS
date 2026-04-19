class SaleItem {
  final String productId;
  final String productName;
  final String productPrice;
  final String quantitySold;
  final DateTime saleDate;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantitySold,
    required this.saleDate,
  });
}
