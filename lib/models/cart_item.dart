class CartItem {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  int quantity;
  final bool isAvailable;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.quantity = 1,
    this.isAvailable = true,
  });

  double get total => price * quantity;
}