class Purchase {
  final int id;
  final String productName;
  final double price;

  Purchase({
    required this.id,
    required this.productName,
    required this.price,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      productName: json['productName'],
      price: json['price'].toDouble(),
    );
  }
}