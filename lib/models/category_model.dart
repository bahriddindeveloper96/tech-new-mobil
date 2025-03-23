import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final int? parentId;
  final int userId;
  final String slug;
  final String image;
  final bool active;
  final bool featured;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;

  CategoryModel({
    required this.id,
    this.parentId,
    required this.userId,
    required this.slug,
    required this.image,
    required this.active,
    required this.featured,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      parentId: json['parent_id'],
      userId: json['user_id'] ?? 0,
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
      active: json['active'] ?? false,
      featured: json['featured'] ?? false,
      order: json['order'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}