import 'package:get/get.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  var isLoading = false.obs;
  var banners = <BannerModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var featuredProducts = <ProductModel>[].obs;
  var newProducts = <ProductModel>[].obs;
  var popularProducts = <ProductModel>[].obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.getHomeData();
      print('Full API Response: $response');

      if (response != null && response['success'] == true && response['data'] != null) {
        final data = response['data'];
        try {
          // Parse banners
          if (data['banners'] != null) {
            print('Raw banners data: ${data['banners']}');
            try {
              banners.value = (data['banners'] as List)
                  .map((banner) => BannerModel.fromJson(banner))
                  .toList();
              print('Parsed banners count: ${banners.length}');
            } catch (e) {
              print('Error parsing banners: $e');
            }
          }

          // Parse categories
          if (data['categories'] != null) {
            print('Raw categories data: ${data['categories']}');
            try {
              categories.value = (data['categories'] as List)
                  .map((category) => CategoryModel.fromJson(category))
                  .toList();
              print('Parsed categories count: ${categories.length}');
            } catch (e) {
              print('Error parsing categories: $e');
            }
          }

          // Parse products
          // Featured products
          if (data['featured_products'] != null) {
            print('Raw featured products data: ${data['featured_products']}');
            try {
              featuredProducts.value = (data['featured_products'] as List)
                  .map((product) => ProductModel.fromJson(product))
                  .toList();
              print('Parsed featured products count: ${featuredProducts.length}');
            } catch (e) {
              print('Error parsing featured products: $e');
            }
          }

          // New products
          if (data['new_products'] != null) {
            print('Raw new products data: ${data['new_products']}');
            try {
              newProducts.value = (data['new_products'] as List)
                  .map((product) => ProductModel.fromJson(product))
                  .toList();
              print('Parsed new products count: ${newProducts.length}');
            } catch (e) {
              print('Error parsing new products: $e');
            }
          }

          // Popular products
          if (data['popular_products'] != null) {
            print('Raw popular products data: ${data['popular_products']}');
            try {
              popularProducts.value = (data['popular_products'] as List)
                  .map((product) => ProductModel.fromJson(product))
                  .toList();
              print('Parsed popular products count: ${popularProducts.length}');
            } catch (e) {
              print('Error parsing popular products: $e');
            }
          }
        } catch (e) {
          print('Error parsing response data: $e');
          error.value = 'Error parsing data: $e';
        }
      } else {
        error.value = 'Invalid response format';
        print('Invalid response format: $response');
      }
    } catch (e) {
      error.value = e.toString();
      print('Error fetching home data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHomeData() async {
    await fetchHomeData();
  }
}
