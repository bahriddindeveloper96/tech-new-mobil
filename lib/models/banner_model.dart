class BannerModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String url;
  final String buttonText;
  final int order;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.url,
    required this.buttonText,
    required this.order,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
      buttonText: json['button_text'],
      order: json['order'],
      active: json['active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
