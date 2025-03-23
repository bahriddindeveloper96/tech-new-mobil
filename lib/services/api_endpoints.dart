class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://192.168.1.108:8000/api';
  static const String storageUrl = 'http://192.168.1.108:8000/storage';
  static const String token = '1|tCbkvFlGsjeqtRQJHhiMPDzVE9xLUzYKvptXXl93a257c9fb';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  
  // Home endpoints
  static const String home = '/homepage';
  static const String banners = '/banners';
  static const String categories = '/categories';
  static const String categoryProducts = '/categories/{id}/products';
  static const String products = '/products';
  static const String featuredProducts = '/products/featured';
  static const String newProducts = '/products/new';
  static const String popularProducts = '/products/popular';
  
  // Cart endpoints
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCart = '/cart/update';
  static const String removeFromCart = '/cart/remove';
  
  // Order endpoints
  static const String orders = '/orders';
  static const String orderDetails = '/orders/';
  static const String createOrder = '/orders/create';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  
  // Favorites endpoints
  static const String favorites = '/favorites';
  static const String addToFavorites = '/favorites/add';
  static const String removeFromFavorites = '/favorites/remove';
}
