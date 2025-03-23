class ApiEndPoints {
  static const String baseUrl = 'http://192.168.1.108:8000/api';
  static const String storageUrl = 'http://192.168.1.108:8000/storage';
  static const String token = '1|laravel_sanctum_dNvRBwPBGWwNNhE5hF4UxEuLIxZBAyTrTZQoZWwl41e47612';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // Products
  static const String products = '/products';
  static const String categories = '/categories';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String cart = '/cart';

  // User
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String addresses = '/addresses';

  static Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
