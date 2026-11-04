class ApiConstants {
  // Android emulator -> host machine. Use http://localhost:30033 for iOS
  // simulator / web, or http://<PC-LAN-IP>:30033 for a physical device.
  static const String baseUrl = 'http://10.0.2.2:30033';

  // Auth
  static const String login = '/api/oauth/token';
  static const String refresh = '/api/oauth/refresh';
  static const String logout = '/api/oauth/logout';

  // Products
  static const String productList = '/api/app/product/list';
  static const String productCreate = '/api/app/product/create';
  static const String productUpdate = '/api/app/product/update';
  static const String productDelete = '/api/app/product/delete';

// Product Categories
  static const String categoryList = '/api/app/product/category/list';
  static const String categoryCreate = '/api/app/product/category/create';

  // Employees (managed through admin user management)

  static const String employeeList = '/api/app/admin/user/list';
  static const String employeeCreate = '/api/app/admin/user/create';
  static const String employeeUpdate = '/api/app/admin/user/update';
  static const String employeeDelete = '/api/app/admin/user/delete';
}
