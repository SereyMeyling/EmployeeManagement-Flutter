import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/token_storage.dart';
import '../modules/auth/login_view.dart';
import '../modules/employees/employee_form_controller.dart';
import '../modules/employees/employee_form_view.dart';
import '../modules/home/home_view.dart';
import '../modules/products/products_view.dart';
import '../modules/dummy_products/bindings/dummy_product_binding.dart';

abstract class Routes {
  static const login = '/login';
  static const home = '/home';
  static const employeeForm = '/employee-form';
  static const products = '/products';
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return TokenStorage.hasToken
        ? null
        : const RouteSettings(name: Routes.login);
  }
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
    ),

    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: Routes.employeeForm,
      page: () => const EmployeeFormView(),
      middlewares: [AuthMiddleware()],
      binding: BindingsBuilder(() {
        Get.lazyPut<EmployeeFormController>(
          () => EmployeeFormController(),
        );
      }),
    ),

    // Products Screen - DummyJSON API
    GetPage(
      name: Routes.products,
      page: () => const ProductsView(),
      middlewares: [AuthMiddleware()],
      binding: DummyProductBinding(),
    ),
  ];
}
