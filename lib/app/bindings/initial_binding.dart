import 'package:get/get.dart';

import '../core/dio_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/employee_repository.dart';
import '../data/repositories/product_repository.dart';
import '../modules/auth/auth_controller.dart';
import '../modules/employees/employee_controller.dart';
import '../modules/home/home_controller.dart';
import '../modules/products/product_controller.dart';
import '../modules/dummy_products/bindings/dummy_product_binding.dart';

/// Controllers are permanent singletons to avoid stale references between
/// routes; their data is cleared on logout and reloaded on login.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final client = Get.put(DioClient(), permanent: true);

    Get.put<AuthRepository>(AuthRepositoryImpl(client), permanent: true);
    Get.put<ProductRepository>(ProductRepositoryImpl(client), permanent: true);
    Get.put<EmployeeRepository>(EmployeeRepositoryImpl(client),
        permanent: true);

    final auth = Get.put(AuthController(Get.find()), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(ProductController(Get.find()), permanent: true);
    Get.put(EmployeeController(Get.find()), permanent: true);

    client.onSessionExpired = auth.forceLogout;
    DummyProductBinding().dependencies();
  }
}
