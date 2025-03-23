class ProductVariant {
  final int id;
  final int productId;
  final double price;
  final int stock;
  final Map<String, dynamic> attributeValues;
  final String sku;
  final bool active;
  final List<String> images;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.price,
    required this.stock,
    required this.attributeValues,
    required this.sku,
    required this.active,
    required this.images,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      productId: json['product_id'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      attributeValues: Map<String, dynamic>.from(json['attribute_values']),
      sku: json['sku'],
      active: json['active'],
      images: List<String>.from(json['images']),
    );
  }
}
