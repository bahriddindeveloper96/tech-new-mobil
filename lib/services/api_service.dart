import 'package:get/get.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class ApiService extends GetxService {
  final ApiClient _client = Get.find<ApiClient>();

  // Home methods
  Future<Map<String, dynamic>> getHomeData() async {
    final response = await _client.get(ApiEndpoints.home);
    return response;
  }

  Future<List<dynamic>> getBanners() async {
    final response = await _client.get(ApiEndpoints.banners);
    return response;
  }

  Future<List<dynamic>> getCategories() async {
    final response = await _client.get(ApiEndpoints.categories);
    return response;
  }

  Future<List<dynamic>> getFeaturedProducts() async {
    final response = await _client.get(ApiEndpoints.featuredProducts);
    return response;
  }

  Future<List<dynamic>> getNewProducts() async {
    final response = await _client.get(ApiEndpoints.newProducts);
    return response;
  }

  Future<List<dynamic>> getPopularProducts() async {
    final response = await _client.get(ApiEndpoints.popularProducts);
    return response;
  }

  // Auth methods
  Future<dynamic> login(String email, String password) async {
    final response = await _client.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  Future<dynamic> register(Map<String, dynamic> userData) async {
    final response = await _client.post(
      ApiEndpoints.register,
      body: userData,
    );
    return response;
  }

  Future<dynamic> logout() async {
    final response = await _client.post(ApiEndpoints.logout);
    return response;
  }

  // Product methods
  Future<List<dynamic>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    String endpoint = '${ApiEndpoints.products}?page=$page&limit=$limit';
    if (category != null) endpoint += '&category=$category';
    if (search != null) endpoint += '&search=$search';

    final response = await _client.get(endpoint);
    return response['data'];
  }

  Future<Map<String, dynamic>> getProductDetails(int id) async {
    final response = await _client.get('${ApiEndpoints.products}/$id');
    return response;
  }

  Future<List<dynamic>> searchProducts(String query) async {
    final response = await _client.get('${ApiEndpoints.products}/search?q=$query');
    return response;
  }

  // Cart methods
  Future<dynamic> getCart() async {
    final response = await _client.get(ApiEndpoints.cart);
    return response;
  }

  Future<dynamic> addToCart(String productId, int quantity) async {
    final response = await _client.post(
      ApiEndpoints.addToCart,
      body: {
        'product_id': productId,
        'quantity': quantity,
      },
    );
    return response;
  }

  Future<dynamic> updateCart(String productId, int quantity) async {
    final response = await _client.put(
      ApiEndpoints.updateCart,
      body: {
        'product_id': productId,
        'quantity': quantity,
      },
    );
    return response;
  }

  Future<dynamic> removeFromCart(String productId) async {
    final response = await _client.delete('${ApiEndpoints.removeFromCart}/$productId');
    return response;
  }

  // Order methods
  Future<List<dynamic>> getOrders() async {
    final response = await _client.get(ApiEndpoints.orders);
    return response['data'];
  }

  Future<dynamic> getOrderDetails(String orderId) async {
    final response = await _client.get('${ApiEndpoints.orderDetails}$orderId');
    return response;
  }

  Future<dynamic> createOrder(Map<String, dynamic> orderData) async {
    final response = await _client.post(
      ApiEndpoints.createOrder,
      body: orderData,
    );
    return response;
  }

  // User methods
  Future<dynamic> getUserProfile() async {
    final response = await _client.get(ApiEndpoints.userProfile);
    return response;
  }

  Future<dynamic> updateProfile(Map<String, dynamic> profileData) async {
    final response = await _client.put(
      ApiEndpoints.updateProfile,
      body: profileData,
    );
    return response;
  }

  // Favorites methods
  Future<List<dynamic>> getFavorites() async {
    final response = await _client.get(ApiEndpoints.favorites);
    return response['data'];
  }

  Future<dynamic> addToFavorites(String productId) async {
    final response = await _client.post(
      ApiEndpoints.addToFavorites,
      body: {'product_id': productId},
    );
    return response;
  }

  Future<dynamic> removeFromFavorites(String productId) async {
    final response = await _client.delete('${ApiEndpoints.removeFromFavorites}/$productId');
    return response;
  }
}
