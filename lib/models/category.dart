class Category {
  final String id;
  final String name;
  final String imageUrl;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'icon': icon,
    };
  }
}