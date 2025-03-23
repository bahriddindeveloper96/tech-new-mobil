import 'category_model.dart';

class ProductModel {
  final int id;
  final String slug;
  final double price;
  final int stock;
  final int categoryId;
  final int userId;
  final bool active;
  final bool featured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? attributes;
  final String name;
  final String description;
  final String averageRating;
  final int favoriteCount;
  final CategoryModel? category;
  final List<ProductVariant> variants;
  final List<ProductImage> images;

  ProductModel({
    required this.id,
    required this.slug,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.userId,
    required this.active,
    required this.featured,
    required this.createdAt,
    required this.updatedAt,
    this.attributes,
    required this.name,
    required this.description,
    required this.averageRating,
    required this.favoriteCount,
    this.category,
    required this.variants,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      active: json['active'] ?? false,
      featured: json['featured'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      attributes: json['attributes'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      averageRating: json['average_rating']?.toString() ?? '0.0',
      favoriteCount: json['favorite_count'] ?? 0,
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((v) => ProductVariant.fromJson(v))
          .toList() ?? [],
      images: (json['images'] as List<dynamic>?)
          ?.map((i) => ProductImage.fromJson(i))
          .toList() ?? [],
    );
  }
}

class ProductVariant {
  final int id;
  final int productId;
  final String price;
  final int stock;
  final Map<String, dynamic> attributeValues;
  final String sku;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> images;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.price,
    required this.stock,
    required this.attributeValues,
    required this.sku,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      price: json['price']?.toString() ?? '0',
      stock: json['stock'] ?? 0,
      attributeValues: json['attribute_values'] ?? {},
      sku: json['sku'] ?? '',
      active: json['active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class ProductImage {
  final String image;

  ProductImage({required this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      image: json['image'] ?? '',
    );
  }
}
