import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../services/api_endpoints.dart';

class CategoryController extends GetxController {
  final categories = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final products = <Map<String, dynamic>>[].obs;
  final category = <String, dynamic>{}.obs;
  final breadcrumbs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(categories, (_) => update()); // Add listener for categories changes
  }

  Future<void> fetchCategories() async {
    if (isLoading.value) return; // Prevent multiple simultaneous fetches
    
    try {
      isLoading.value = true;
      error.value = '';
      
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.categories}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiEndpoints.token}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
          final List<dynamic> rawCategories = data['data'];
          final processedCategories = rawCategories.map<Map<String, dynamic>>((category) {
            return _processCategory(Map<String, dynamic>.from(category));
          }).toList();
          
          // Update categories in a single batch
          categories.assignAll(processedCategories);
        }
      } else {
        error.value = 'Failed to load categories';
      }
    } catch (e) {
      print('Error fetching categories: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _processCategory(Map<String, dynamic> category) {
    final processed = Map<String, dynamic>.from(category);
    
    // Fix image URL
    if (processed['image'] != null) {
      final imageUrl = processed['image'].toString();
      processed['image'] = _normalizeImageUrl(imageUrl);
    }
    
    // Process children recursively
    if (processed['children'] != null) {
      final List<dynamic> children = processed['children'];
      processed['children'] = children.map<Map<String, dynamic>>((child) {
        return _processCategory(Map<String, dynamic>.from(child));
      }).toList();
    }
    
    return processed;
  }

  String _normalizeImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http')) return imageUrl;
    if (imageUrl.startsWith('/')) {
      return 'http://192.168.1.108:8000$imageUrl';
    }
    return 'http://192.168.1.108:8000/$imageUrl';
  }

  String getLocalizedName(Map<String, dynamic> category, String locale) {
    try {
      final translations = category['translations'] as List<dynamic>?;
      if (translations != null && translations.isNotEmpty) {
        final localizedName = translations.firstWhere(
          (t) => t['locale'] == locale,
          orElse: () => translations.first,
        )['name'];
        return localizedName ?? category['name'] ?? '';
      }
      return category['name'] ?? '';
    } catch (e) {
      return category['name'] ?? '';
    }
  }

  String getLocalizedDescription(Map<String, dynamic> category, String locale) {
    try {
      final translations = category['translations'] as List<dynamic>?;
      if (translations != null && translations.isNotEmpty) {
        final localizedDesc = translations.firstWhere(
          (t) => t['locale'] == locale,
          orElse: () => translations.first,
        )['description'];
        return localizedDesc ?? category['description'] ?? '';
      }
      return category['description'] ?? '';
    } catch (e) {
      return category['description'] ?? '';
    }
  }

  String? getImageUrl(Map<String, dynamic> category) {
    if (category['image'] == null) return null;
    return _normalizeImageUrl(category['image'].toString());
  }

  Future<void> fetchCategoryProducts(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      products.clear();

      final url = Uri.parse('${ApiEndpoints.baseUrl}/categories/$id/products');
      print('Fetching products for category ID: $id');
      print('API URL: $url');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${ApiEndpoints.token}',
        },
      );

      print('Products Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final responseData = data['data'];

          // Set category data
          if (responseData['category'] != null) {
            category.value = responseData['category'];
          }

          // Set breadcrumbs
          if (responseData['breadcrumbs'] != null) {
            breadcrumbs.assignAll(List<Map<String, dynamic>>.from(responseData['breadcrumbs']));
          }

          // Set products
          if (responseData['products'] != null) {
            products.assignAll(List<Map<String, dynamic>>.from(responseData['products']));
            if (products.isEmpty) {
              error.value = 'no_products_in_category'.tr;
            }
          } else {
            error.value = 'no_products_in_category'.tr;
          }
        } else {
          error.value = data['message'] ?? 'error_loading_data'.tr;
        }
      } else {
        error.value = 'error_loading_data'.tr;
      }
    } catch (e) {
      print('Error fetching category products: $e');
      error.value = 'error_loading_data'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}