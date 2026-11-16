class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://shoppix.runasp.net/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // products
  static const String allProducts = '/products';

  static const String orders = '/orders';

  //product by id

  static String getProductById(int id) => '/products/$id';
  static String getRelatedProducts(int id) => '/products/$id/related';
}
