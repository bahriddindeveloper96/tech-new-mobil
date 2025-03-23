class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // Home endpoints
  static const String home = '/home';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String banners = '/banners';
  
  // Product endpoints
  static const String product = '/products';
  static const String productDetails = '/products/';  // Add product ID at the end
  static const String productReviews = '/products/reviews/';  // Add product ID at the end
  static const String productFavorite = '/products/favorite/';  // Add product ID at the end
  
  // Cart endpoints
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static const String cartRemove = '/cart/remove';
  static const String cartUpdate = '/cart/update';
  
  // Order endpoints
  static const String orders = '/orders';
  static const String orderDetails = '/orders/';  // Add order ID at the end
  
  // User endpoints
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String changePassword = '/profile/change-password';
  
  // Favorites
  static const String favorites = '/favorites';
  
  // Search
  static const String search = '/search';
}
