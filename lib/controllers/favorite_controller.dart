import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final RxList<Map<String, dynamic>> favoriteProducts = <Map<String, dynamic>>[].obs;

  void addToFavorites(Map<String, dynamic> product) {
    if (!favoriteProducts.any((p) => p['id'] == product['id'])) {
      favoriteProducts.add(product);
      Get.snackbar(
        'Added to Favorites',
        '${product['name']} has been added to your favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeFromFavorites(String productId) {
    final product = favoriteProducts.firstWhere((p) => p['id'] == productId);
    favoriteProducts.removeWhere((p) => p['id'] == productId);
    Get.snackbar(
      'Removed from Favorites',
      '${product['name']} has been removed from your favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearFavorites() {
    favoriteProducts.clear();
    Get.snackbar(
      'Favorites Cleared',
      'All products have been removed from your favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool isFavorite(String productId) {
    return favoriteProducts.any((p) => p['id'] == productId);
  }
}