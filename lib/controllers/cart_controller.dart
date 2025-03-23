import 'package:get/get.dart';

class CartController extends GetxController {
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  final RxDouble total = 0.0.obs;

  void addToCart(Map<String, dynamic> product) {
    final existingItem = cartItems.firstWhereOrNull((item) => item['id'] == product['id']);
    
    if (existingItem != null) {
      final newQuantity = (existingItem['quantity'] as int) + (product['quantity'] as int);
      existingItem['quantity'] = newQuantity;
      cartItems.refresh();
    } else {
      if (!product.containsKey('quantity')) {
        product['quantity'] = 1;
      }
      cartItems.add(product);
    }
    Get.snackbar(
      'Savatga qo\'shildi',
      '${product['name']} savatga qo\'shildi',
      snackPosition: SnackPosition.BOTTOM,
    );
    _updateTotal();
  }

  void removeFromCart(String productId) {
    try {
      final product = cartItems.firstWhere((item) => item['id'].toString() == productId);
      cartItems.removeWhere((item) => item['id'].toString() == productId);
      Get.snackbar(
        'Savatdan o\'chirildi',
        '${product['name']} savatdan o\'chirildi',
        snackPosition: SnackPosition.BOTTOM,
      );
      _updateTotal();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  void clearCart() {
    cartItems.clear();
    Get.snackbar(
      'Savat tozalandi',
      'Barcha mahsulotlar savatdan o\'chirildi',
      snackPosition: SnackPosition.BOTTOM,
    );
    _updateTotal();
  }

  void incrementQuantity(String productId) {
    try {
      final item = cartItems.firstWhere((item) => item['id'].toString() == productId);
      item['quantity'] = (item['quantity'] as int) + 1;
      cartItems.refresh();
      _updateTotal();
    } catch (e) {
      print('Error incrementing quantity: $e');
    }
  }

  void decrementQuantity(String productId) {
    try {
      final item = cartItems.firstWhere((item) => item['id'].toString() == productId);
      if ((item['quantity'] as int) > 1) {
        item['quantity'] = (item['quantity'] as int) - 1;
        cartItems.refresh();
      } else {
        removeFromCart(productId);
      }
      _updateTotal();
    } catch (e) {
      print('Error decrementing quantity: $e');
    }
  }

  void updateQuantity(String productId, int? quantity) {
    try {
      if (quantity == null || quantity <= 0) {
        removeFromCart(productId);
        return;
      }
      
      final item = cartItems.firstWhere((item) => item['id'].toString() == productId);
      item['quantity'] = quantity;
      cartItems.refresh();
      _updateTotal();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  void _updateTotal() {
    total.value = cartItems.fold(0.0, (sum, item) {
      return sum + (item['price'] as double) * (item['quantity'] as int);
    });
  }

  int get itemCount => cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
}