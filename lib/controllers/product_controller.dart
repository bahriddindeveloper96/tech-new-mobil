import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../services/api_endpoints.dart';

class ProductController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> productData = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> featuredProducts = <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> selectedVariant = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> colors = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> storageOptions = <Map<String, dynamic>>[].obs;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${ApiEndpoints.token}',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  String? _processImageUrl(dynamic imageUrl) {
    if (imageUrl == null) return null;
    if (imageUrl is Map) {
      imageUrl = imageUrl['image'];
    }
    if (imageUrl is! String) return null;
    
    // Check if the URL is already a full URL
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    
    // Remove any leading slash and combine with storage URL
    return '${ApiEndpoints.storageUrl}/${imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl}';
  }

  List<String> _processImageList(dynamic images) {
    if (images == null) return [];
    List<String> processedImages = [];
    
    if (images is List) {
      for (var image in images) {
        final processedUrl = _processImageUrl(image);
        if (processedUrl != null) {
          processedImages.add(processedUrl);
        }
      }
    } else if (images is String) {
      // Handle single image string
      final processedUrl = _processImageUrl(images);
      if (processedUrl != null) {
        processedImages.add(processedUrl);
      }
    }
    return processedImages.toSet().toList(); // Remove duplicates
  }

  Future<void> getProduct(String id) async {
    try {
      isLoading.value = true;
      
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/products/$id');
      print('Request URL: $uri');
      print('Request Headers: $_headers');
      
      final response = await http.get(
        uri,
        headers: _headers,
      );
      
      print('Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('API Response: $responseData');
        
        if (responseData['message'] == 'Product retrieved successfully') {
          final Map<String, dynamic> data = responseData['data'];
          
          // Process main product data
          if (data['data'] != null) {
            productData.value = Map<String, dynamic>.from(data['data']);
            print('Product Data: ${productData.value}');
            
            // Process variants
            if (productData['variants']?.isNotEmpty == true) {
              // Set initial selected variant
              selectedVariant.value = Map<String, dynamic>.from(productData['variants'][0]);
              print('Selected Variant: ${selectedVariant.value}');
              
              // Extract colors
              final Set<String> uniqueColors = {};
              final List<Map<String, dynamic>> colorsList = [];
              
              for (var variant in List<Map<String, dynamic>>.from(productData['variants'])) {
                final variantColor = variant['attribute_values']?['color']?.toString();
                if (variantColor != null && !uniqueColors.contains(variantColor)) {
                  uniqueColors.add(variantColor);
                  colorsList.add({
                    'name': variantColor,
                    'color': _getColorFromName(variantColor),
                  });
                }
              }
              colors.value = colorsList;
              print('Colors: ${colors.value}');
              
              // Extract storage options
              final Set<String> uniqueStorage = {};
              final List<Map<String, dynamic>> storageList = [];
              
              for (var variant in List<Map<String, dynamic>>.from(productData['variants'])) {
                final variantStorage = variant['attribute_values']?['storage']?.toString();
                final variantPrice = variant['price'];
                if (variantStorage != null && variantPrice != null && !uniqueStorage.contains(variantStorage)) {
                  uniqueStorage.add(variantStorage);
                  storageList.add({
                    'size': variantStorage,
                    'price': double.tryParse(variantPrice.toString()) ?? 0.0,
                  });
                }
              }
              
              if (storageList.isNotEmpty) {
                storageList.sort((a, b) {
                  final sizeA = int.tryParse(a['size'].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                  final sizeB = int.tryParse(b['size'].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                  return sizeA.compareTo(sizeB);
                });
                storageOptions.value = storageList;
              }
              print('Storage Options: ${storageOptions.value}');
            }
          }
          
          // Process featured products
          if (data['featured_products'] != null) {
            featuredProducts.value = List<Map<String, dynamic>>.from(
              data['featured_products'].map((product) => Map<String, dynamic>.from(product))
            );
            print('Featured Products: ${featuredProducts.length}');
          }
        } else {
          print('API Error: ${responseData['message']}');
          throw Exception('Failed to load product: ${responseData['message']}');
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching product: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedVariant({String? color, String? storage}) {
    if (productData['variants'] == null) return;

    for (var variant in List<Map<String, dynamic>>.from(productData['variants'])) {
      if (variant['attribute_values'] == null) continue;
      
      final variantColor = variant['attribute_values']['color']?.toString();
      final variantStorage = variant['attribute_values']['storage']?.toString();
      
      if ((color == null || variantColor == color) && 
          (storage == null || variantStorage == storage)) {
        selectedVariant.value = Map<String, dynamic>.from(variant);
        print('Updated Selected Variant: ${selectedVariant.value}');
        break;
      }
    }
  }

  List<String> getProductImages(Map<String, dynamic> product) {
    List<String> images = [];
    
    // Add variant images if available and selected variant exists
    if (selectedVariant.isNotEmpty) {
      final variantImages = selectedVariant['images'];
      if (variantImages is List) {
        images.addAll(List<String>.from(variantImages));
      }
    }
    // Otherwise add all variant images
    else if (product['variants'] != null) {
      for (var variant in List<Map<String, dynamic>>.from(product['variants'])) {
        final variantImages = variant['images'];
        if (variantImages is List) {
          images.addAll(List<String>.from(variantImages));
        }
      }
    }
    
    return images.toSet().toList(); // Remove duplicates
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
      case 'titanium black':
        return const Color(0xFF2C2C2C);
      case 'silver':
      case 'titanium gray':
        return const Color(0xFFE3E3E3);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'titanium violet':
        return const Color(0xFF8B00FF);
      default:
        return const Color(0xFF000000);
    }
  }

  Map<String, List<String>> getProductSpecifications(Map<String, dynamic> product) {
    Map<String, List<String>> specs = {};
    if (product['variants']?.isNotEmpty == true) {
      final firstVariant = Map<String, dynamic>.from(product['variants'][0]);
      if (firstVariant['attribute_values'] != null) {
        final attributeValues = Map<String, dynamic>.from(firstVariant['attribute_values']);
        attributeValues.forEach((key, value) {
          specs[key] = List<Map<String, dynamic>>.from(product['variants'])
              .map((v) => v['attribute_values'][key]?.toString() ?? '')
              .where((v) => v.isNotEmpty)
              .toSet()
              .toList();
        });
      }
    }
    return specs;
  }

  double getBasePrice() {
    if (selectedVariant.isNotEmpty && selectedVariant['price'] != null) {
      return double.tryParse(selectedVariant['price'].toString()) ?? 0.0;
    }
    return 0.0;
  }

  double? getOldPrice() {
    final currentPrice = getBasePrice();
    if (currentPrice > 0) {
      return currentPrice * 1.1; // 10% higher than current price
    }
    return null;
  }

  bool isProductNew(Map<String, dynamic> product) {
    if (product['created_at'] != null) {
      final createdAt = DateTime.tryParse(product['created_at']);
      if (createdAt != null) {
        final now = DateTime.now();
        return now.difference(createdAt).inDays <= 7;
      }
    }
    return false;
  }

  bool isProductDiscounted() {
    return getOldPrice() != null;
  }
}
