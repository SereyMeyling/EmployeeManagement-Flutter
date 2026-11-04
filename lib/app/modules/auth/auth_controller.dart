import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_pages.dart';
import '../employees/employee_controller.dart';
import '../home/home_controller.dart';
import '../products/product_controller.dart';

class AuthController extends GetxController {
  final AuthRepository _repo;
  AuthController(this._repo);

  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final isLoading = false.obs;
  final obscure = true.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await _repo.login(phoneCtrl.text.trim(), passCtrl.text);
      passCtrl.clear();
      Get.find<HomeController>().index.value = 0;
      Get.offAllNamed(Routes.home);
      Get.find<ProductController>().fetch();
      Get.find<EmployeeController>().fetch();
    } on AppException catch (e) {
      _error('Login failed', e.message);
    } catch (_) {
      _error('Login failed', 'Unexpected response from server.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    await _repo.logout();
    isLoading.value = false;
    _resetAndGoToLogin();
  }

  /// Called when the refresh token is rejected.
  void forceLogout() {
    _repo.logout();
    _resetAndGoToLogin();
    _error('Session expired', 'Please sign in again.');
  }

  void _resetAndGoToLogin() {
    Get.find<ProductController>().clear();
    Get.find<EmployeeController>().clear();
    Get.offAllNamed(Routes.login);
  }

  void _error(String title, String msg) => Get.snackbar(
        title,
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
}
