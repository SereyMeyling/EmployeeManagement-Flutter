import 'package:get/get.dart';

import '../core/token_storage.dart';
import '../modules/auth/login_view.dart';
import '../modules/employees/employee_form_controller.dart';
import '../modules/employees/employee_form_view.dart';
import '../modules/home/home_view.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  static const login = '/login';
  static const home = '/home';
  static const employeeForm = '/employee-form';
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      TokenStorage.hasToken ? null : const RouteSettings(name: Routes.login);
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: Routes.login, page: () => const LoginView()),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.employeeForm,
      page: () => const EmployeeFormView(),
      middlewares: [AuthMiddleware()],
      binding: BindingsBuilder(
          () => Get.lazyPut<EmployeeFormController>(() => EmployeeFormController())),
    ),
  ];
}
