class Product {
  final String productName;
  final String productId;
  final String productCode;
  final String image;
  final String productQuantity;
  final String productPrice;
  final String productTotalPrice;
  final String creationDate;

  Product(
      {required this.productName,
      required this.productId,
      required this.image,
      required this.productCode,
      required this.productQuantity,
      required this.productPrice,
      required this.productTotalPrice,
      required this.creationDate});
}
//